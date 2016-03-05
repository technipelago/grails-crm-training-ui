<%@ page import="grails.plugins.crm.training.CrmTraining" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmTraining.label', default: 'Training')}"/>
    <title><g:message code="crmTraining.edit.title" args="[entityName, crmTraining]"/></title>
    <g:if test="${htmlContent}">
        <ckeditor:resources/>
    </g:if>
    <r:script>
    $(document).ready(function() {
        <% if (htmlContent) { %>
        var stylesheet = ["${resource(dir: 'less', file: 'bootstrap.less.css', plugin: 'twitter-bootstrap')}",
            "${resource(dir: 'less', file: 'crm-ui-bootstrap.less.css', plugin: 'crm-ui-bootstrap')}",
            "${resource(dir: 'less', file: 'responsive.less.css', plugin: 'twitter-bootstrap')}"];
            var editor = CKEDITOR.replace('content',
            {
                customConfig: "${resource(dir: 'js', file: 'crm-ckeditor-config.js', plugin: 'crm-content-ui')}",
                stylesSet: "crm-web-styles:${
            resource(dir: 'js', file: 'crm-ckeditor-styles.js', plugin: 'crm-content-ui')}",
                baseHref: '',//"${createLink(controller: 'static')}",
                contentsCss: stylesheet,
                filebrowserBrowseUrl: "${
            createLink(controller: 'crmContent', action: 'browse')}?reference=crmTraining@${crmTraining.ident()}&status=shared",
                filebrowserUploadUrl: "${createLink(controller: 'crmContent', action: 'upload')}",
                filebrowserImageBrowseUrl: "${
            createLink(controller: 'crmContent', action: 'browse')}?pattern=image&reference=crmTraining@${
            crmTraining.ident()}&status=shared",
                filebrowserImageUploadUrl: "${createLink(controller: 'crmContent', action: 'upload')}"
            });
        <% } %>
        });
    </r:script>
</head>

<body>

<crm:header title="crmTraining.edit.title" subtitle="${crmTraining.type.encodeAsHTML()}"
            args="[entityName, crmTraining]"/>

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

<g:form action="edit">

    <f:with bean="crmTraining">

        <g:hiddenField name="id" value="${crmTraining?.id}"/>
        <g:hiddenField name="version" value="${crmTraining?.version}"/>

        <div class="tabbable">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#main" data-toggle="tab"><g:message
                        code="crmTraining.tab.main.label"/></a>
                </li>
                <li><a href="#desc" data-toggle="tab" accesskey="d"><g:message
                        code="crmTraining.tab.desc.label"/></a></li>
                <g:if test="${htmlContent}">
                    <li><a href="#html" data-toggle="tab"><g:message code="crmTraining.tab.html.label"
                                                                     default="Presentation"/>(1)</a></li>
                </g:if>
            </ul>

            <div class="tab-content">
                <div class="tab-pane active" id="main">
                    <div class="row-fluid">

                        <div class="span4">
                            <div class="row-fluid">
                                <f:field property="number" label="crmTraining.number.label" input-class="span6" input-autofocus=""/>
                                <f:field property="product" label="crmTraining.product.label" input-class="span6"/>
                                <f:field property="name" label="crmTraining.name.label" input-class="span11"/>
                            </div>
                        </div>

                        <div class="span4">
                            <div class="row-fluid">
                                <f:field property="type">
                                    <g:select name="type.id" from="${metadata.typeList}"
                                              optionKey="id" value="${crmTraining.type?.id}" class="span11"/>
                                </f:field>

                                <f:field property="scope" label="crmTraining.scope.label" input-class="span11"/>
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
                    <g:textArea name="description" rows="20" cols="80"
                                value="${crmTraining.description}" class="span11"/>
                </div>

                <g:if test="${htmlContent}">
                    <div class="tab-pane" id="html">
                        <g:textArea id="content" name="text" cols="80" rows="15" class="span11"
                                                        value="${htmlContent.text}"/>
                    </div>
                </g:if>
            </div>
        </div>

        <div class="form-actions">
            <crm:button visual="warning" icon="icon-ok icon-white" label="crmTraining.button.update.label"/>
            <crm:button action="delete" visual="danger" icon="icon-trash icon-white"
                        label="crmTraining.button.delete.label"
                        confirm="crmTraining.button.delete.confirm.message" permission="crmTraining:delete"/>
            <crm:button type="link" action="show" id="${crmTraining.id}"
                        icon="icon-remove"
                        label="crmTraining.button.cancel.label"/>
        </div>

    </f:with>

</g:form>

</body>
</html>
