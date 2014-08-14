package grails.plugins.crm.training

import org.springframework.dao.DataIntegrityViolationException

import javax.servlet.http.HttpServletResponse

/**
 * CRUD controller for CrmTrainingType.
 */
class CrmTrainingTypeController {

    static allowedMethods = [create: ['GET', 'POST'], edit: ['GET', 'POST'], delete: 'POST']

    static navigation = [
            [group: 'admin',
                    order: 340,
                    title: 'crmTrainingType.label',
                    action: 'index'
            ]
    ]

    def selectionService
    def crmTrainingService

    def domainClass = CrmTrainingType

    def index() {
        redirect action: 'list', params: params
    }

    def list() {
        def baseURI = new URI('gorm://crmTrainingType/list')
        def query = params.getSelectionQuery()
        def uri

        switch (request.method) {
            case 'GET':
                uri = params.getSelectionURI() ?: selectionService.addQuery(baseURI, query)
                break
            case 'POST':
                uri = selectionService.addQuery(baseURI, query)
                grails.plugins.crm.core.WebUtils.setTenantData(request, 'crmTrainingTypeQuery', query)
                break
        }

        params.max = Math.min(params.max ? params.int('max') : 20, 100)

        try {
            def result = selectionService.select(uri, params)
            [crmTrainingTypeList: result, crmTrainingTypeTotal: result.totalCount, selection: uri]
        } catch (Exception e) {
            flash.error = e.message
            [crmTrainingTypeList: [], crmTrainingTypeTotal: 0, selection: uri]
        }
    }

    def create() {
        def crmTrainingType = crmTrainingService.createTrainingType(params)
        switch (request.method) {
            case 'GET':
                return [crmTrainingType: crmTrainingType]
            case 'POST':
                if (!crmTrainingType.save(flush: true)) {
                    render view: 'create', model: [crmTrainingType: crmTrainingType]
                    return
                }
                flash.success = message(code: 'crmTrainingType.created.message', args: [message(code: 'crmTrainingType.label', default: 'Training Type'), crmTrainingType.toString()])
                redirect action: 'list'
                break
        }
    }

    def edit() {
        switch (request.method) {
            case 'GET':
                def crmTrainingType = domainClass.get(params.id)
                if (!crmTrainingType) {
                    flash.error = message(code: 'crmTrainingType.not.found.message', args: [message(code: 'crmTrainingType.label', default: 'Training Type'), params.id])
                    redirect action: 'list'
                    return
                }

                return [crmTrainingType: crmTrainingType]
            case 'POST':
                def crmTrainingType = domainClass.get(params.id)
                if (!crmTrainingType) {
                    flash.error = message(code: 'crmTrainingType.not.found.message', args: [message(code: 'crmTrainingType.label', default: 'Training Type'), params.id])
                    redirect action: 'list'
                    return
                }

                if (params.version) {
                    def version = params.version.toLong()
                    if (crmTrainingType.version > version) {
                        crmTrainingType.errors.rejectValue('version', 'crmTrainingType.optimistic.locking.failure',
                                [message(code: 'crmTrainingType.label', default: 'Status')] as Object[],
                                "Another user has updated this Status while you were editing")
                        render view: 'edit', model: [crmTrainingType: crmTrainingType]
                        return
                    }
                }

                crmTrainingType.properties = params

                if (!crmTrainingType.save(flush: true)) {
                    render view: 'edit', model: [crmTrainingType: crmTrainingType]
                    return
                }

                flash.success = message(code: 'crmTrainingType.updated.message', args: [message(code: 'crmTrainingType.label', default: 'Training Type'), crmTrainingType.toString()])
                redirect action: 'list'
                break
        }
    }

    def delete() {
        def crmTrainingType = domainClass.get(params.id)
        if (!crmTrainingType) {
            flash.error = message(code: 'crmTrainingType.not.found.message', args: [message(code: 'crmTrainingType.label', default: 'Training Type'), params.id])
            redirect action: 'list'
            return
        }

        if (isInUse(crmTrainingType)) {
            render view: 'edit', model: [crmTrainingType: crmTrainingType]
            return
        }

        try {
            def tombstone = crmTrainingType.toString()
            crmTrainingType.delete(flush: true)
            flash.warning = message(code: 'crmTrainingType.deleted.message', args: [message(code: 'crmTrainingType.label', default: 'Training Type'), tombstone])
            redirect action: 'list'
        }
        catch (DataIntegrityViolationException e) {
            flash.error = message(code: 'crmTrainingType.not.deleted.message', args: [message(code: 'crmTrainingType.label', default: 'Training Type'), params.id])
            redirect action: 'edit', id: params.id
        }
    }

    private boolean isInUse(CrmTrainingType type) {
        def count = CrmTraining.countByType(type)
        def rval = false
        if (count) {
            flash.error = message(code: "crmTrainingType.delete.error.reference", args:
                    [message(code: 'crmTrainingType.label', default: 'Training Type'),
                            message(code: 'crmSalesProject.label', default: 'Trainings'), count],
                    default: "This {0} is used by {1} {2}")
            rval = true
        }

        return rval
    }

    def moveUp(Long id) {
        def target = domainClass.get(id)
        if (target) {
            def sort = target.orderIndex
            def prev = domainClass.createCriteria().list([sort: 'orderIndex', order: 'desc']) {
                lt('orderIndex', sort)
                maxResults 1
            }?.find { it }
            if (prev) {
                domainClass.withTransaction { tx ->
                    target.orderIndex = prev.orderIndex
                    prev.orderIndex = sort
                }
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND)
        }
        redirect action: 'list'
    }

    def moveDown(Long id) {
        def target = domainClass.get(id)
        if (target) {
            def sort = target.orderIndex
            def next = domainClass.createCriteria().list([sort: 'orderIndex', order: 'asc']) {
                gt('orderIndex', sort)
                maxResults 1
            }?.find { it }
            if (next) {
                domainClass.withTransaction { tx ->
                    target.orderIndex = next.orderIndex
                    next.orderIndex = sort
                }
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND)
        }
        redirect action: 'list'
    }
}
