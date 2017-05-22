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

                <g:sortableColumn property="type.name"
                                  title="${message(code: 'crmTraining.type.label', default: 'Type')}"/>

                <g:sortableColumn property="product"
                                  title="${message(code: 'crmTraining.product.label', default: 'Product')}"/>

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
                        ${fieldValue(bean: crmTraining, field: "type")}
                    </td>

                    <td>
                        ${fieldValue(bean: crmTraining, field: "product")}
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>

        <crm:paginate total="${crmTrainingTotal}"/>

        <g:form class="form-actions btn-toolbar">
            <input type="hidden" name="offset" value="${params.offset ?: ''}"/>
            <input type="hidden" name="max" value="${params.max ?: ''}"/>
            <input type="hidden" name="sort" value="${params.sort ?: ''}"/>
            <input type="hidden" name="order" value="${params.order ?: ''}"/>

            <g:each in="${selection.selectionMap}" var="entry">
                <input type="hidden" name="${entry.key}" value="${entry.value}"/>
            </g:each>

            <crm:selectionMenu visual="primary"/>

            <g:if test="${crmTrainingTotal}">
                <select:link action="export" accesskey="p" selection="${selection}" class="btn btn-info">
                    <i class="icon-print icon-white"></i>
                    <g:message code="crmTraining.button.export.label" default="Print/Export"/>
                </select:link>
            </g:if>

            <crm:button type="link" group="true" action="create" visual="success" icon="icon-file icon-white"
                        label="crmTraining.button.create.label" permission="crmTraining:create"/>
        </g:form>

    </div>

    <div class="span3">
        <tmpl:events list="${eventList}"/>
    </div>

</div>

</body>
</html>
