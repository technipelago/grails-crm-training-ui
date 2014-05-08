<table class="table table-striped">
    <thead>
    <tr>
        <th><g:message code="crmTraining.number.label" default="Number"/></th>

        <g:sortableColumn property="name"
                          title="${message(code: 'crmTraining.name.label', default: 'Name')}"/>

        <g:sortableColumn property="type.name"
                          title="${message(code: 'crmTraining.type.label', default: 'Type')}"/>

    </tr>
    </thead>
    <tbody>
    <g:each in="${result}" var="crmTraining">
        <tr>

            <td>
                <g:link controller="crmTraining" action="show" id="${crmTraining.id}">
                    ${fieldValue(bean: crmTraining, field: "number")}
                </g:link>
            </td>

            <td>
                <g:link controller="crmTraining" action="show" id="${crmTraining.id}">
                    ${fieldValue(bean: crmTraining, field: "name")}
                </g:link>
            </td>

            <td>

                ${fieldValue(bean: crmTraining, field: "type")}

            </td>

        </tr>
    </g:each>
    </tbody>
</table>

<div class="form-actions btn-toolbar">
    <crm:button type="link" group="true" action="create" visual="success"
                icon="icon-file icon-white"
                label="crmTraining.button.create.label"
                title="crmTraining.button.create.help"
                permission="crmTraining:create"
                params="${createParams}">
    </crm:button>
</div>
