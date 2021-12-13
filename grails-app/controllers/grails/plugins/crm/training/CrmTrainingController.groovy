/*
 * Copyright (c) 2015 Goran Ehrsson.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package grails.plugins.crm.training

import grails.plugins.crm.core.TenantUtils
import grails.plugins.crm.core.WebUtils
import grails.plugins.crm.content.CrmResourceRef
import grails.transaction.Transactional
import org.springframework.dao.DataIntegrityViolationException

import java.util.concurrent.TimeoutException

/**
 * CrmTraining CRUD controller.
 */
class CrmTrainingController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def crmSecurityService
    def crmCoreService
    def selectionService
    def crmTrainingService
    def crmTaskService
    def userTagService
    def crmContentService

    def index() {
        // If any query parameters are specified in the URL, let them override the last query stored in session.
        def cmd = new CrmTrainingQueryCommand()
        def query = params.getSelectionQuery()
        bindData(cmd, query ?: WebUtils.getTenantData(request, 'crmTrainingQuery'))
        def events = crmTrainingService.listTrainingEvents([fromDate: new Date() - 7], [max: 5, sort: 'startTime', order: 'asc'])
        [cmd: cmd, eventList: events]
    }

    def list() {
        def baseURI = new URI('bean://crmTrainingService/list')
        def query = params.getSelectionQuery()
        def uri

        switch (request.method) {
            case 'GET':
                uri = params.getSelectionURI() ?: selectionService.addQuery(baseURI, query)
                break
            case 'POST':
                uri = selectionService.addQuery(baseURI, query)
                WebUtils.setTenantData(request, 'crmTrainingQuery', query)
                break
        }

        params.max = Math.min(params.max ? params.int('max') : 10, 100)

        def result
        try {
            result = selectionService.select(uri, params)
            if (result.totalCount == 1) {
                redirect action: "show", id: result.head().ident()
            } else {
                def events = crmTrainingService.listTrainingEvents([fromDate: new Date() - 5], [max: 5, sort: 'startTime', order: 'asc'])
                [crmTrainingList: result, crmTrainingTotal: result.totalCount, selection: uri, eventList: events]
            }
        } catch (Exception e) {
            flash.error = e.message
            [crmTrainingList: [], crmTrainingTotal: 0, selection: uri]
        }
    }

    def clearQuery() {
        WebUtils.setTenantData(request, 'crmTrainingQuery', null)
        redirect(action: 'index')
    }

    def create() {
        def tenant = TenantUtils.tenant
        def crmTraining = crmTrainingService.createTraining(params)
        def metadata = [:]
        metadata.typeList = CrmTrainingType.findAllByTenantId(tenant)
        metadata.vatList = getVatOptions()
        metadata.currency = grailsApplication.config.crm.currency.default ?: 'EUR'

        switch (request.method) {
            case "GET":
                return [crmTraining: crmTraining, metadata: metadata]
            case "POST":
                bindData(crmTraining, params, [include: CrmTraining.BIND_WHITELIST])

                if (crmTraining.save()) {
                    // TODO hack!
                    if (!params.text) {
                        params.text = "<h2>${crmTraining}</h2>\n<p>${crmTraining.description ?: ''}</p>\n"
                    }
                    if (params.text) {
                        crmContentService.createResource(params.text, 'presentation.html', crmTraining, [contentType: 'text/html', status: CrmResourceRef.STATUS_SHARED])
                    }
                    flash.success = message(code: 'crmTraining.created.message', args: [message(code: 'crmTraining.label', default: 'Training'), crmTraining.toString()])
                    redirect(action: "show", id: crmTraining.id)
                } else {
                    render(view: "create", model: [crmTraining: crmTraining, metadata: metadata])
                }
                break
        }
    }

    def show(Long id) {
        def crmTraining = CrmTraining.findByIdAndTenantId(id, TenantUtils.tenant)
        if (!crmTraining) {
            flash.error = message(code: 'crmTraining.not.found.message', args: [message(code: 'crmTraining.label', default: 'Training'), id])
            redirect(action: "index")
            return
        }
        def schedule = crmTaskService.list([reference: crmTraining], [:])
        def html = crmContentService.findResourcesByReference(crmTraining, [name: "*.html", status: CrmResourceRef.STATUS_SHARED])?.find {
            it
        }
        def currency = grailsApplication.config.crm.currency.default ?: 'EUR'
        def taskTypeParam = grailsApplication.config.crm.training.task.type ?: 'training'
        def taskType = crmTaskService.getTaskType(taskTypeParam)
        [crmTraining: crmTraining, reference: crmCoreService.getReferenceIdentifier(crmTraining),
         currency: currency, htmlContent: html, events: schedule, taskType: taskType]
    }

    @Transactional
    def edit(Long id) {
        def tenant = TenantUtils.tenant
        def crmTraining = CrmTraining.findByIdAndTenantId(id, tenant)
        if (!crmTraining) {
            flash.error = message(code: 'crmTraining.not.found.message', args: [message(code: 'crmTraining.label', default: 'Training'), id])
            redirect(action: "index")
            return
        }

        def html = crmContentService.findResourcesByReference(crmTraining, [name: "*.html", status: CrmResourceRef.STATUS_SHARED])?.find {
            it
        }
        def metadata = [:]
        metadata.typeList = CrmTrainingType.findAllByTenantId(tenant)
        metadata.vatList = getVatOptions()
        metadata.currency = grailsApplication.config.crm.currency.default ?: 'EUR'

        switch (request.method) {
            case "GET":
                return [crmTraining: crmTraining, metadata: metadata, htmlContent: html]
            case "POST":
                if (params.int('version') != null) {
                    if (crmTraining.version > params.int('version')) {
                        crmTraining.errors.rejectValue("version", "crmTraining.optimistic.locking.failure",
                                [message(code: 'crmTraining.label', default: 'Training')] as Object[],
                                "Another user has updated this Training while you were editing")
                        render(view: "edit", model: [crmTraining: crmTraining, metadata: metadata, htmlContent: html])
                        return
                    }
                }

                bindData(crmTraining, params, [include: CrmTraining.BIND_WHITELIST])

                if (crmTraining.save(flush: true)) {
                    // TODO hack!
                    if (!params.text) {
                        params.text = "<h2>${crmTraining}</h2>\n<p>${crmTraining.description ?: ''}</p>\n"
                    }
                    if (html) {
                        if (params.text) {
                            def inputStream = new ByteArrayInputStream(params.text.getBytes('UTF-8'))
                            crmContentService.updateResource(html, inputStream, 'text/html')
                        } else {
                            crmContentService.deleteReference(html)
                        }
                    } else if (params.text) {
                        crmContentService.createResource(params.text, 'presentation.html', crmTraining, [contentType: 'text/html', status: CrmResourceRef.STATUS_SHARED])
                    }
                    flash.success = message(code: 'crmTraining.updated.message', args: [message(code: 'crmTraining.label', default: 'Training'), crmTraining.toString()])
                    redirect(action: "show", id: crmTraining.id)
                } else {
                    render(view: "edit", model: [crmTraining: crmTraining, metadata: metadata, htmlContent: html])
                }
                break
        }
    }

    def delete(Long id) {
        def crmTraining = CrmTraining.findByIdAndTenantId(id, TenantUtils.tenant)
        if (!crmTraining) {
            flash.error = message(code: 'crmTraining.not.found.message', args: [message(code: 'crmTraining.label', default: 'Training'), id])
            redirect(action: "index")
            return
        }

        try {
            def tombstone = crmTraining.toString()
            crmTraining.delete(flush: true)
            flash.warning = message(code: 'crmTraining.deleted.message', args: [message(code: 'crmTraining.label', default: 'Training'), tombstone])
            redirect(action: "index")
        }
        catch (DataIntegrityViolationException e) {
            flash.error = message(code: 'crmTraining.not.deleted.message', args: [message(code: 'crmTraining.label', default: 'Training'), id])
            redirect(action: "show", id: id)
        }
    }

    def export() {
        def user = crmSecurityService.getUserInfo()
        def ns = params.ns ?: 'crmTraining'
        if (request.post) {
            def filename = message(code: 'crmTraining.label', default: 'Training')
            try {
                def timeout = (grailsApplication.config.crm.training.export.timeout ?: 60) * 1000
                def topic = params.topic ?: 'export'
                def result = event(for: ns, topic: topic,
                        data: params + [user: user, tenant: TenantUtils.tenant, locale: request.locale, filename: filename]).waitFor(timeout)?.value
                if (result?.file) {
                    try {
                        WebUtils.inlineHeaders(response, result.contentType, result.filename ?: ns)
                        WebUtils.renderFile(response, result.file)
                    } finally {
                        result.file.delete()
                    }
                    return null // Success
                } else {
                    flash.warning = message(code: 'crmTraining.export.nothing.message', default: 'Nothing was exported')
                }
            } catch (TimeoutException te) {
                flash.error = message(code: 'crmTraining.export.timeout.message', default: 'Export did not complete')
            } catch (Exception e) {
                log.error("Export event throwed an exception", e)
                flash.error = message(code: 'crmTraining.export.error.message', default: 'Export failed due to an error', args: [e.message])
            }
            redirect(action: "index")
        } else {
            def uri = params.getSelectionURI()
            def layouts = event(for: ns, topic: (params.topic ?: 'exportLayout'),
                    data: [tenant: TenantUtils.tenant, username: user.username, uri: uri, locale: request.locale]).waitFor(10000)?.values?.flatten()
            [layouts: layouts, selection: uri]
        }
    }

    def createFavorite(Long id) {
        def crmTraining = crmTrainingService.getTraining(id)
        if (!crmTraining) {
            flash.error = message(code: 'crmTraining.not.found.message', args: [message(code: 'crmTraining.label', default: 'Training'), id])
            redirect action: 'index'
            return
        }
        userTagService.tag(crmTraining, grailsApplication.config.crm.tag.favorite, crmSecurityService.currentUser?.username, TenantUtils.tenant)

        redirect(action: 'show', id: params.id)
    }

    def deleteFavorite(Long id) {
        def crmTraining = crmTrainingService.getTraining(id)
        if (!crmTraining) {
            flash.error = message(code: 'crmTraining.not.found.message', args: [message(code: 'crmTraining.label', default: 'Training'), id])
            redirect action: 'index'
            return
        }
        userTagService.untag(crmTraining, grailsApplication.config.crm.tag.favorite, crmSecurityService.currentUser?.username, TenantUtils.tenant)
        redirect(action: 'show', id: params.id)
    }

    private List getVatOptions() {
        getVatList().collect {
            [label: "${it}%", value: (it / 100).doubleValue()]
        }
    }

    private List<Number> getVatList() {
        grailsApplication.config.crm.currency.vat.list ?: [0]
    }
}
