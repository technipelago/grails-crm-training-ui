<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmTraining.label', default: 'Training')}"/>
    <title><g:message code="crmTraining.list.title" args="[entityName]"/></title>
</head>

<body>

<crm:header title="crmTraining.list.title"
            subtitle="Sökningen resulterade i ${crmTrainingTotal} st utbildningar"
            args="[entityName]">
</crm:header>

<div class="row-fluid">
    <div class="span9">
        <table class="table table-striped">
            <thead>
            <tr>
                <g:sortableColumn property="number"
                                  title="${message(code: 'crmTraining.number.label', default: 'Number')}"/>
                <g:sortableColumn property="name"
                                  title="${message(code: 'crmTraining.name.label', default: 'Name of training')}"/>

                <g:sortableColumn property="url"
                                  title="${message(code: 'crmTraining.url.label', default: 'URL')}"/>

                <g:sortableColumn property="type.name"
                                  title="${message(code: 'crmTraining.type.label', default: 'Type')}"/>

            </tr>
            </thead>
            <tbody>
            <g:each in="${crmTrainingList}" var="crmTraining">
                <tr>

                    <td>
                        <g:link action="show" id="${crmTraining.id}">
                            ${fieldValue(bean: crmTraining, field: "number")}
                        </g:link>
                    </td>

                    <td>
                        <g:link action="show" id="${crmTraining.id}">
                            ${fieldValue(bean: crmTraining, field: "name")}
                        </g:link>
                    </td>


                    <td>
                        ${fieldValue(bean: crmTraining, field: "url")}
                    </td>

                    <td>
                        ${fieldValue(bean: crmTraining, field: "type")}
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>

        <crm:paginate total="${crmTrainingTotal}"/>

        <div class="form-actions  btn-toolbar">
            <g:form>
                <input type="hidden" name="offset" value="${params.offset ?: ''}"/>
                <input type="hidden" name="max" value="${params.max ?: ''}"/>
                <input type="hidden" name="sort" value="${params.sort ?: ''}"/>
                <input type="hidden" name="order" value="${params.order ?: ''}"/>

                <g:each in="${selection.selectionMap}" var="entry">
                    <input type="hidden" name="${entry.key}" value="${entry.value}"/>
                </g:each>

                <crm:selectionMenu visual="primary"/>

                <g:if test="${crmTrainingTotal}">
                    <div class="btn-group">
                        <button class="btn btn-info dropdown-toggle" data-toggle="dropdown">
                            <i class="icon-print icon-white"></i>
                            <g:message code="crmTraining.button.print.label" default="Print"/>
                            <span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu">
                            <crm:hasPermission permission="crmTraining:print">
                                <li>
                                    <select:link action="print" accesskey="p" target="pdf" selection="${selection}">
                                        <g:message code="crmTraining.button.print.pdf.label" default="Print to PDF"/>
                                    </select:link>
                                </li>
                            </crm:hasPermission>
                            <crm:hasPermission permission="crmTraining:export">
                                <li>
                                    <select:link action="export" accesskey="e" selection="${selection}">
                                        <g:message code="crmTraining.button.export.calc.label"
                                                   default="Print to spreadsheet"/>
                                    </select:link>
                                </li>
                            </crm:hasPermission>
                        </ul>
                    </div>
                </g:if>

                <crm:button type="link" group="true" action="create" visual="success" icon="icon-file icon-white"
                            label="crmTraining.button.create.label" permission="crmTraining:create"/>
            </g:form>
        </div>

    </div>

    <div class="span3">
        <tmpl:events list="${eventList}"/>
    </div>

</div>

</body>
</html>
