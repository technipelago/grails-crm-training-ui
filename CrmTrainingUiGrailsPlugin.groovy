class CrmTrainingUiGrailsPlugin {
    def groupId = ""
    def version = "2.0.0"
    def grailsVersion = "2.2 > *"
    def dependsOn = [:]
    def loadAfter = ['crmTraining']
    def pluginExcludes = [
            "grails-app/conf/ApplicationResources.groovy",
            "src/groovy/grails/plugins/crm/training/TestSecurityDelegate.groovy",
            "grails-app/views/error.gsp"
    ]
    def title = "GR8 CRM Training Administration User Interface"
    def author = "Goran Ehrsson"
    def authorEmail = "goran@technipelago.se"
    def description = '''\
Provides (admin) user interface for training administration in GR8 CRM applications
'''
    def documentation = "http://gr8crm.github.io/plugins/crm-training-ui"
    def license = "APACHE"
    def organization = [name: "Technipelago AB", url: "http://www.technipelago.se/"]
    def issueManagement = [system: "github", url: "https://github.com/technipelago/grails-crm-training-ui/issues"]
    def scm = [url: "https://github.com/technipelago/grails-crm-training-ui"]
}
