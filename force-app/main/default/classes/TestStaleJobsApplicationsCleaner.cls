@isTest
public class TestStaleJobsApplicationsCleaner {
    @TestSetup
    static void setup(){
        JobApplication__c jobApp = new JobApplication__c(
            Name = 'First'
        );
        insert jobApp;
    }

    @isTest
    public static void StaleJobsApplicationsCleaner_updateToStale_successfull(){
        JobApplication__c jobApp = [SELECT Id FROM JobApplication__c LIMIT 1];
        jobApp.FollowUpDate__c = System.today().addDays(-35);
        jobApp.Status__c = 'Saved';
        update jobApp;

        Test.startTest();
        StaleJobsApplicationsCleaner batchCleaner = new StaleJobsApplicationsCleaner();
        Database.executeBatch(batchCleaner);
        Test.stopTest();

        JobApplication__c updatedRecord = [SELECT Notes__c, Status__c FROM JobApplication__c LIMIT 1];
        System.assertEquals(String.isNotBlank(updatedRecord.Notes__c), true, 'Notes were populated');
        System.assertEquals(updatedRecord.Status__c, 'Closed', 'Status was updated');

    }
    @isTest
    static void StaleJobsApplicationsCleanerScheduler_scheduling_success() {       
        Test.startTest();
        
        String cronExp = '0 0 0 ? * * *'; // Daily at midnight
        String jobName = 'StaleJobsApplicationsCleanerScheduler';
        StaleJobsApplicationsCleanerScheduler scheduler = new StaleJobsApplicationsCleanerScheduler();
        String jobId = System.schedule(jobName, cronExp, scheduler);
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered 
                        FROM CronTrigger 
                        WHERE Id = :jobId];
        System.assertEquals(cronExp, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
    }
}