<%@ page import="grails.plugins.crm.training.CrmTrainingType; grails.plugins.crm.core.TenantUtils" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmTraining.label', default: 'Training')}"/>
    <title><g:message code="crmTraining.find.title" args="[entityName]"/></title>
    <r:require module="datepicker"/>
    <r:script>
        $(document).ready(function () {
            <crm:datepicker/>
        });
    </r:script>
</head>

<body>

<crm:header title="crmTraining.find.title" args="[entityName]"/>

<div class="row-fluid">
    <div class="span9">
        <g:form action="list">

            <div class="row-fluid">

                <f:with bean="cmd">
                    <div class="span4">
                        <f:field property="number" label="crmTraining.number.label" input-class="span12"
                                 input-autofocus=""
                                 input-placeholder="${message(code: 'crmTrainingQueryCommand.number.placeholder', default: '')}"/>
                        <f:field property="name" label="crmTraining.name.label"
                                 input-class="span12"
                                 input-placeholder="${message(code: 'crmTrainingQueryCommand.name.placeholder', default: '')}"/>
                        <f:field property="type" label="crmTraining.type.label"
                                 input-placeholder="${message(code: 'crmTrainingQueryCommand.type.placeholder', default: '')}">
                            <g:select from="${CrmTrainingType.findAllByTenantId(TenantUtils.tenant)}"
                                      name="type" optionKey="param" class="span12" noSelection="['': '']"/>
                        </f:field>
                    </div>

                    <div class="span4">
                        <f:field property="fromDate">
                            <div class="inline input-append date"
                                 data-date="${cmd.fromDate ?: new Date().format('yyyy-MM-dd')}">
                                <g:textField name="fromDate" class="span12" size="10" placeholder="ÅÅÅÅ-MM-DD"
                                             value="${cmd.fromDate}"/><span
                                    class="add-on"><i class="icon-th"></i></span>
                            </div>
                        </f:field>
                        <f:field property="toDate">
                            <div class="inline input-append date"
                                 data-date="${cmd.toDate ?: new Date().format('yyyy-MM-dd')}">
                                <g:textField name="toDate" class="span12" size="10" placeholder="ÅÅÅÅ-MM-DD"
                                             value="${cmd.toDate}"/><span
                                    class="add-on"><i class="icon-th"></i></span>
                            </div>
                        </f:field>

                        <f:field property="location" label="crmTask.location.label"
                                 input-class="span12"
                                 input-placeholder="${message(code: 'crmTrainingQueryCommand.location.placeholder', default: '')}"/>
                    </div>

                    <div class="span4">
                        <f:field property="customer" label="crmTrainingQueryCommand.customer.label" input-class="span12"
                                 input-placeholder="${message(code: 'crmTrainingQueryCommand.customer.placeholder', default: '')}"/>

                        <f:field property="tags" label="crmTrainingQueryCommand.tags.label">
                            <g:textField name="tags" class="span12" value="${cmd.tags}"
                                         placeholder="${message(code: 'crmTrainingQueryCommand.tags.placeholder', default: '')}"/>
                        </f:field>
                    </div>
                </f:with>

            </div>

            <div class="form-actions btn-toolbar">
                <crm:selectionMenu visual="primary">
                    <crm:button action="list" icon="icon-search icon-white" visual="primary"
                                label="crmTraining.button.search.label"/>
                </crm:selectionMenu>
                <crm:button type="link" group="true" action="create" visual="success" icon="icon-file icon-white"
                            label="crmTraining.button.create.label" permission="crmTraining:create"/>
                <g:link action="clearQuery" class="btn btn-link"><g:message
                        code="crmTraining.button.query.clear.label"
                        default="Reset fields"/></g:link>
            </div>

        </g:form>
    </div>

    <div class="span3">
        <tmpl:events list="${eventList}"/>
    </div>
</div>
</body>
</html>
