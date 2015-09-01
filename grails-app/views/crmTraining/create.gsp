<%@ page import="grails.plugins.crm.training.CrmTraining" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmTraining.label', default: 'Training')}"/>
    <title><g:message code="crmTraining.create.title" args="[entityName, crmTraining]"/></title>
</head>

<body>

<crm:header title="crmTraining.create.title" args="[entityName, crmTraining]"/>

<g:hasErrors bean="${crmTraining}">
    <crm:alert class="alert-error">
        <ul>
            <g:eachError bean="${crmTraining}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                        error="${error}"/></li>
            </g:eachError>
        </ul>
    </crm:alert>
</g:hasErrors>

<g:form action="create">

    <f:with bean="crmTraining">

        <div class="tabbable">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#main" data-toggle="tab"><g:message
                        code="crmTraining.tab.main.label"/></a>
                </li>
                <li><a href="#desc" data-toggle="tab" accesskey="d"><g:message
                        code="crmTraining.tab.desc.label"/></a></li>

            </ul>

            <div class="tab-content">
                <div class="tab-pane active" id="main">
                    <div class="row-fluid">

                        <div class="span4">
                            <div class="row-fluid">
                                <f:field property="number" label="crmTraining.number.label" input-class="span6"/>
                                <f:field property="name" label="crmTraining.name.label" input-class="span11"/>
                                <f:field property="url" label="crmTraining.url.label" input-class="span11"/>
                            </div>
                        </div>

                        <div class="span4">
                            <div class="row-fluid">
                                <f:field property="type">
                                    <g:select name="type.id" from="${metadata.typeList}"
                                              optionKey="id" value="${crmTraining.type?.id}" class="span11"/>
                                </f:field>

                                <f:field property="scope" label="crmTraining.scope.label" input-class="span11"/>
                                <div class="row-fluid">
                                    <div class="span6">
                                        <div class="control-group">
                                            <label class="control-label">
                                                <g:message code="crmTraining.price.label"/>
                                            </label>
                                            <div class="controls">
                                                <input type="text" name="price" value="${formatNumber(number:crmTraining.price, minFractionDigits: 2)}" class="span12"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="span6">
                                        <div class="control-group">
                                            <label class="control-label">
                                                <g:message code="crmTraining.vat.label" default="VAT"/>
                                            </label>
                                            <div class="controls">
                                                <g:select name="vat" from="${metadata.vatList}" value="${formatNumber(number:crmTraining.vat, minFractionDigits: 2)}"
                                                          optionKey="${{formatNumber(number:it.value, minFractionDigits: 2)}}" optionValue="label" class="span10"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="span4">
                            <div class="row-fluid">
                                <f:field property="maxAttendees" label="crmTraining.maxAttendees.label" input-class="span3"/>
                                <f:field property="autoConfirm" label="crmTraining.autoConfirm.label" input-class="span3"/>
                                <f:field property="overbook" label="crmTraining.overbook.label" input-class="span3"/>
                            </div>
                        </div>

                    </div>
                </div>

                <div class="tab-pane" id="desc">
                    <f:field property="description">
                        <g:textArea name="description" rows="10" cols="80"
                                    value="${crmTraining.description}" class="span11"/>
                    </f:field>
                </div>
            </div>
        </div>

        <div class="form-actions">
            <crm:button visual="success" icon="icon-ok icon-white" label="crmTraining.button.save.label"/>
        </div>


    </f:with>

</g:form>

</body>
</html>
