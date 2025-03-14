public class JoobleNewJobsFinder implements Queueable, Database.AllowsCallouts{
    
    public void execute(QueueableContext context){
        final String ENDPOINT = 'callout:JoobleCredentials';
        final String METHOD = 'POST';
        final String FULL_TIME = 'Full-time';

        List<JobApplication__c> jobAppList = new List<JobApplication__c>();
        Map<String, String> companyNamesJobIds = new Map<String, String>();
        Integer page = 0;
        Integer recordsPerPage = 20;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod(METHOD);
        req.setHeader('Content-type', 'application/json');
        req.setBody('{"keywords":"Salesforce Developer","location":"Miami, Florida","salary":10000}');

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('Received response' + res.getBody());
        
        if (res.getStatusCode() == 200) {
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody().toString());
            if (m.values() != null) {
                for (Object job : (List<Object>)m.get('jobs')) {
                    Map<String, Object> objMap = (Map<String, Object>) job;
                    JobApplication__c jobApp = new JobApplication__c();
                    jobApp.PositionTitle__c = (String) objMap.get('title');
                    jobApp.Location__c = (String) objMap.get('location');
                    jobApp.Description__c = ((String) objMap.get('snippet')).stripHtmlTags();
                    jobApp.Notes__c = (String) objMap.get('type');
                    String jobId = String.valueOf((Long) objMap.get('id')).remove('-');
                    jobApp.JobId__c = jobId;
                    jobApp.URL__c = (String) objMap.get('link');
                    String jobType = (String) objMap.get('type');
                    String salary = (String) objMap.get('salary');
                    if (jobType != null && jobType == FULL_TIME && salary != null && salary.contains('k')) {
                        jobApp.Salary__c = Integer.valueOf(salary.substringAfter('- $').remove('k'))*1000;
                    }
                    jobAppList.add(jobApp);
                    companyNamesJobIds.put(jobId, (String) objMap.get('company'));
                    
                }
            }
        }
        if (!jobAppList.isEmpty()) {
            upsert jobAppList JobId__c;
        }
        if (!companyNamesJobIds.values().isEmpty() && !Test.isRunningTest()) {
            System.enqueueJob(new createAndAttachCompanies(companyNamesJobIds));
        }
        
    }
}