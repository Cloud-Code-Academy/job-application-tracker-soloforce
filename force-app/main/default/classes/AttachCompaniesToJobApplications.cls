public class AttachCompaniesToJobApplications implements Queueable{

    private Map<String, String> companyNamesJobIds;

    public AttachCompaniesToJobApplications(Map<String, String> companyNamesJobIdsMap) {
        this.companyNamesJobIds = companyNamesJobIdsMap;
    }
    
    public void execute(QueueableContext context) {
        Map<String, Id> companiesMap = new Map<String, Id>();
        List<JobApplication__c> jobAppsForUpdate = new List<JobApplication__c>();
        for (Account acc : [SELECT Id, Name FROM Account WHERE Name IN: companyNamesJobIds.values()]) {
            companiesMap.put(acc.Name, acc.Id);
        }

        for (JobApplication__c jobApp : [SELECT Id,Company__c,JobId__c FROM JobApplication__c WHERE JobId__c IN: companyNamesJobIds.keySet()]) {
            if (jobApp.Company__c == null) {
                jobApp.Company__c = companiesMap.get(companyNamesJobIds.get(jobApp.JobId__c));
                jobAppsForUpdate.add(jobApp);
            }
        }

        if (!jobAppsForUpdate.isEmpty()) {
            update jobAppsForUpdate;
        }
    }
}

