<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmTrainingType.label', default: 'Training Type')}"/>
    <title><g:message code="crmTrainingType.edit.title" args="[entityName, crmTrainingType]"/></title>
</head>

<body>

<crm:header title="crmTrainingType.edit.title" args="[entityName, crmTrainingType]"/>

<div class="row-fluid">
    <div class="span9">

        <g:hasErrors bean="${crmTrainingType}">
            <crm:alert class="alert-error">
                <ul>
                    <g:eachError bean="${crmTrainingType}" var="error">
                        <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                                error="${error}"/></li>
                    </g:eachError>
                </ul>
            </crm:alert>
        </g:hasErrors>

        <g:form class="form-horizontal" action="edit"
                id="${crmTrainingType?.id}">
            <g:hiddenField name="version" value="${crmTrainingType?.version}"/>

            <f:with bean="crmTrainingType">
                <f:field property="name" input-autofocus=""/>
                <f:field property="description"/>
                <f:field property="param"/>
                <f:field property="icon"/>
                <f:field property="orderIndex"/>
                <f:field property="enabled"/>
            </f:with>

            <div class="form-actions">
                <crm:button visual="primary" icon="icon-ok icon-white" label="crmTrainingType.button.update.label"/>
                <crm:button action="delete" visual="danger" icon="icon-trash icon-white"
                            label="crmTrainingType.button.delete.label"
                            confirm="crmTrainingType.button.delete.confirm.message"
                            permission="crmTrainingType:delete"/>
                                <crm:button type="link" action="list"
                            icon="icon-remove"
                            label="crmTrainingType.button.cancel.label"/>
            </div>
        </g:form>
    </div>

    <div class="span3">
        <crm:submenu/>
    </div>
</div>
</body>
</html>
