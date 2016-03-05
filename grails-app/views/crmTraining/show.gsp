<%@ page import="grails.plugins.crm.core.DateUtils; grails.plugins.crm.training.CrmTraining" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmTraining.label', default: 'Training')}"/>
    <title><g:message code="crmTraining.show.title" args="[entityName, crmTraining]"/></title>
    <r:script>
        $(document).ready(function () {
            // Position the cursor in first field when modals are opened.
            $('.modal').on('shown', function () {
                $('input:visible:enabled:first', this).focus();
            });
        });
    </r:script>
</head>

<body>

<div class="row-fluid">
    <div class="span9">

        <header class="page-header clearfix">
            <h1>
                ${crmTraining.encodeAsHTML()}
                <crm:favoriteIcon bean="${crmTraining}"/>
                <small>${crmTraining.type.encodeAsHTML()}</small>
            </h1>
        </header>

        <div class="tabbable">
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="#main" data-toggle="tab"><g:message code="crmTraining.tab.main.label"/></a>
                </li>
                <g:if test="${htmlContent}">
                    <li><a href="#html" data-toggle="tab"><g:message code="crmTraining.tab.html.label"
                                                                     default="Presentation"/>(1)</a></li>
                </g:if>
                <li>
                    <a href="#events" data-toggle="tab">
                        <g:message code="crmTraining.tab.events.label"/>
                        <crm:countIndicator count="${events.size()}"/>
                    </a>
                </li>
                <crm:pluginViews location="tabs" var="view">
                    <crm:pluginTab id="${view.id}" label="${view.label}" count="${view.model?.totalCount}"/>
                </crm:pluginViews>
            </ul>

            <div class="tab-content">
                <div class="tab-pane active" id="main">
                    <div class="row-fluid">
                        <div class="span4">
                            <dl>

                                <g:if test="${crmTraining.number}">
                                    <dt><g:message code="crmTraining.number.label" default="Number"/></dt>

                                    <dd><g:fieldValue bean="${crmTraining}" field="number"/></dd>

                                </g:if>

                                <g:if test="${crmTraining.name}">
                                    <dt><g:message code="crmTraining.name.label" default="Name"/></dt>

                                    <dd><g:fieldValue bean="${crmTraining}" field="name"/></dd>

                                </g:if>

                                <g:if test="${crmTraining.product}">
                                    <dt><g:message code="crmTraining.product.label" default="Product"/></dt>

                                    <dd>
                                        <g:link mapping="crm-product-show" params="${[id: crmTraining.product]}">
                                            <g:fieldValue bean="${crmTraining}" field="product"/>
                                        </g:link>
                                    </dd>

                                </g:if>

                            </dl>
                        </div>

                        <div class="span4">
                            <dl>

                                <dt><g:message code="crmTraining.type.label" default="Type"/></dt>

                                <dd><g:fieldValue bean="${crmTraining}" field="type"/></dd>

                                <g:if test="${crmTraining.scope}">
                                    <dt><g:message code="crmTraining.scope.label" default="Scope"/></dt>

                                    <dd><g:fieldValue bean="${crmTraining}" field="scope"/></dd>

                                </g:if>

                            </dl>

                        </div>

                        <div class="span4">

                            <dl>

                                <g:if test="${crmTraining.maxAttendees != null}">
                                    <dt><g:message code="crmTraining.maxAttendees.label"/></dt>
                                    <dd><g:formatNumber number="${crmTraining.maxAttendees}"/></dd>
                                </g:if>

                                <g:if test="${crmTraining.autoConfirm != null}">
                                    <dt><g:message code="crmTraining.autoConfirm.label"/></dt>
                                    <dd><g:formatNumber number="${crmTraining.autoConfirm}"/></dd>
                                </g:if>

                                <g:if test="${crmTraining.overbook != null}">
                                    <dt><g:message code="crmTraining.overbook.label"/></dt>
                                    <dd><g:formatNumber number="${crmTraining.overbook}"/></dd>
                                </g:if>

                            </dl>

                        </div>

                    </div>

                    <g:if test="${crmTraining.description}">
                        <dl style="margin-top: 0;">
                            <dt><g:message code="crmTraining.description.label" default="Description"/></dt>
                            <dd><g:decorate encode="HTML" nlbr="true">${crmTraining.description}</g:decorate></dd>
                        </dl>
                    </g:if>

                    <g:form>
                        <g:hiddenField name="id" value="${crmTraining.id}"/>
                        <div class="form-actions btn-toolbar">

                            <crm:selectionMenu location="crmTraining" visual="primary">
                                <crm:button type="link" controller="crmTraining" action="index"
                                            visual="primary" icon="icon-search icon-white"
                                            label="crmTraining.find.label" permission="crmTraining:show"/>
                            </crm:selectionMenu>

                            <crm:button type="link" group="true" action="edit" id="${crmTraining.id}" visual="warning"
                                        icon="icon-pencil icon-white"
                                        label="crmTraining.button.edit.label" permission="crmTraining:edit">
                                <button class="btn btn-warning dropdown-toggle" data-toggle="dropdown">
                                    <span class="caret"></span>
                                </button>
                                <ul class="dropdown-menu">
                                </ul>
                            </crm:button>

                            <crm:button type="link" group="true" action="create"
                                        visual="success" icon="icon-file icon-white"
                                        label="crmTraining.button.create.label"
                                        title="crmTraining.button.create.help"
                                        permission="crmTraining:create">
                            </crm:button>

                            <div class="btn-group">
                                <button class="btn btn-info dropdown-toggle" data-toggle="dropdown">
                                    <i class="icon-info-sign icon-white"></i>
                                    <g:message code="crmTraining.button.view.label" default="View"/>
                                    <span class="caret"></span>
                                </button>
                                <ul class="dropdown-menu">
                                    <crm:hasPermission permission="crmTraining:createFavorite">
                                        <crm:user>
                                            <g:if test="${crmTraining.isUserTagged('favorite', username)}">
                                                <li>
                                                    <g:link action="deleteFavorite" id="${crmTraining.id}"
                                                            title="${message(code: 'crmTraining.button.favorite.delete.help', args: [crmTraining])}">
                                                        <g:message
                                                                code="crmTraining.button.favorite.delete.label"/></g:link>
                                                </li>
                                            </g:if>
                                            <g:else>
                                                <li>
                                                    <g:link action="createFavorite" id="${crmTraining.id}"
                                                            title="${message(code: 'crmTraining.button.favorite.create.help', args: [crmTraining])}">
                                                        <g:message
                                                                code="crmTraining.button.favorite.create.label"/></g:link>
                                                </li>
                                            </g:else>
                                        </crm:user>
                                    </crm:hasPermission>
                                </ul>
                            </div>
                        </div>

                        <crm:timestamp bean="${crmTraining}"/>

                    </g:form>

                </div>

                <g:if test="${htmlContent}">
                    <div class="tab-pane" id="html">
                        <crm:render template="${htmlContent}" parser="raw" authorized="true"/>
                    </div>
                </g:if>

                <div class="tab-pane" id="events">
                    <div class="row-fluid">
                        <tmpl:schedule list="${events}" bean="${crmTraining}"/>
                    </div>
                </div>

                <crm:pluginViews location="tabs" var="view">
                    <div class="tab-pane tab-${view.id}" id="${view.id}">
                        <g:render template="${view.template}" model="${view.model}" plugin="${view.plugin}"/>
                    </div>
                </crm:pluginViews>

            </div>
        </div>

    </div>

    <div class="span3">

        <div class="alert alert-info">
            <g:render template="summary" model="${[bean: crmTraining]}"/>
        </div>

        <g:render template="/tags" plugin="crm-tags" model="${[bean: crmTraining]}"/>

    </div>
</div>

</body>
</html>
