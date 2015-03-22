<ul class="nav nav-list">
    <li class="nav-header"><g:message code="crmTraining.current.events.title"/></li>
    <g:each in="${list}" var="crmTask">
        <li><g:link controller="crmTask" action="show" id="${crmTask.id}">
            ${crmTask.displayDate ?: formatDate(format:'d MMM', date: crmTask.startTime)}
            ${crmTask.encodeAsHTML()}
        </g:link></li>
    </g:each>
</ul>