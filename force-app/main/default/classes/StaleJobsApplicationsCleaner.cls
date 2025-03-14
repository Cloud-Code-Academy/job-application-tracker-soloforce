global class StaleJobsApplicationsCleaner implements Database.Batchable<SObject>, Database.Stateful{
    Date thirtyDaysAgo;
    String[] avoidStatuses = new String[]{'Closed','Accepted'};
    final String UPDATED_NOTES = 'Job Application was closed by an automated process';
    final String CLOSED_STATUS = 'Closed';

    global StaleJobsApplicationsCleaner(){
        this.thirtyDaysAgo = System.today().addDays(-30);
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([
            SELECT Notes__c
            FROM JobApplication__c
            WHERE Status__c NOT IN:(avoidStatuses) AND FollowUpDate__c <=: thirtyDaysAgo
        ]);
    }
    global void execute(Database.BatchableContext BC, List<JobApplication__c> scope){
        List<ErrorLog__c> errorLogs = new List<ErrorLog__c>();
        List<JobApplication__c> jobApplicationsForUpdate = new List<JobApplication__c>();

        for (JobApplication__c japplication : scope) {
            japplication.Notes__c = UPDATED_NOTES;
            japplication.Status__c = CLOSED_STATUS;
        }

        try {
            update scope;
        } catch (Exception ex) {
            ErrorLog__c error = new ErrorLog__c();
            error.ClassName__c = 'StaleJobsApplicationsCleaner';
            error.ErrorMessage__c = ex.getMessage();
            errorLogs.add(error);
        }

        if (!errorLogs.isEmpty()) {
            insert errorLogs;
        }
    }
    global void finish(Database.BatchableContext BC){
        StaleJobsApplicationsCleaner newBatch = new StaleJobsApplicationsCleaner();
    }
}