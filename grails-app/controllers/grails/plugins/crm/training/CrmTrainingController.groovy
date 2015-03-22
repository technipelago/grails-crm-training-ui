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
import org.springframework.dao.DataIntegrityViolationException

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

    def index() {
        // If any query parameters are specified in the URL, let them override the last query stored in session.
        def cmd = new CrmTrainingQueryCommand()
        def query = params.getSelectionQuery()
        bindData(cmd, query ?: WebUtils.getTenantData(request, 'crmTrainingQuery'))
        def events = crmTrainingService.listTrainingEvents([fromDate:new Date() - 5], [max: 5, sort: 'startTime', order: 'asc'])
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
                def events = crmTrainingService.listTrainingEvents([fromDate:new Date() - 5], [max: 5, sort: 'startTime', order: 'asc'])
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

        switch (request.method) {
            case "GET":
                return [crmTraining: crmTraining, metadata: metadata]
            case "POST":
                bindData(crmTraining, params, [include: CrmTraining.BIND_WHITELIST])

                if (crmTraining.hasErrors() || !crmTraining.save()) {
                    render(view: "create", model: [crmTraining: crmTraining, metadata: metadata])
                    return
                }

                flash.success = message(code: 'crmTraining.created.message', args: [message(code: 'crmTraining.label', default: 'Training'), crmTraining.toString()])
                redirect(action: "show", id: crmTraining.id)
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
        [crmTraining: crmTraining, reference: crmCoreService.getReferenceIdentifier(crmTraining), events: schedule]
    }

    def edit(Long id) {
        def tenant = TenantUtils.tenant
        def crmTraining = CrmTraining.findByIdAndTenantId(id, tenant)
        if (!crmTraining) {
            flash.error = message(code: 'crmTraining.not.found.message', args: [message(code: 'crmTraining.label', default: 'Training'), id])
            redirect(action: "index")
            return
        }

        def metadata = [:]
        metadata.typeList = CrmTrainingType.findAllByTenantId(tenant)

        switch (request.method) {
            case "GET":
                return [crmTraining: crmTraining, metadata: metadata]
            case "POST":
                if (params.int('version') != null) {
                    if (crmTraining.version > params.int('version')) {
                        crmTraining.errors.rejectValue("version", "crmTraining.optimistic.locking.failure",
                                [message(code: 'crmTraining.label', default: 'Training')] as Object[],
                                "Another user has updated this Training while you were editing")
                        render(view: "edit", model: [crmTraining: crmTraining, metadata: metadata])
                        return
                    }
                }

                bindData(crmTraining, params, [include: CrmTraining.BIND_WHITELIST])

                if (!crmTraining.save(flush: true)) {
                    render(view: "edit", model: [crmTraining: crmTraining, metadata: metadata])
                    return
                }

                flash.success = message(code: 'crmTraining.updated.message', args: [message(code: 'crmTraining.label', default: 'Training'), crmTraining.toString()])
                redirect(action: "show", id: crmTraining.id)
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
}
