<table class="table table-striped">
    <thead>
    <tr>
        <th><g:message code="crmTask.number.label" default="Number"/></th>
        <th><g:message code="crmTask.date.label" default="Date"/></th>
        <th><g:message code="crmTask.name.label" default="Name"/></th>
        <th><g:message code="crmTask.location.label" default="Location"/></th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${list}" var="crmTask">
        <tr class="${crmTask.completed ? 'disabled' : ''}">
            <td class="nowrap">
                <g:link controller="crmTask" action="show" id="${crmTask.id}">
                    ${fieldValue(bean: crmTask, field: "number")}
                </g:link>
            </td>
            <td class="nowrap">
                <g:link controller="crmTask" action="show" id="${crmTask.id}">
                    <g:formatDate type="date" date="${crmTask.startTime}"/>
                </g:link>
            </td>

            <td>
                <g:link controller="crmTask" action="show" id="${crmTask.id}">
                    ${fieldValue(bean: crmTask, field: "name")}
                </g:link>
            </td>

            <td>
                ${fieldValue(bean: crmTask, field: "location")}
            </td>
        </tr>
    </g:each>
    </tbody>
</table>

<div class="form-actions btn-toolbar">
    <crm:button type="link" group="true" controller="crmTask" action="create" params="${[ref: reference, name: bean.toString(), 'type.id': taskType?.id]}"
                visual="success"
                icon="icon-file icon-white"
                label="crmTraining.button.create.event.label" permission="crmTask:create"/>
</div>
