@isTest
public class TestAttachCompaniesToJobApplications {
    @TestSetup
    static void setup(){
        Account company = new Account(
            Name = 'Golden company'
        );
        insert company;
        JobApplication__c jobApp = new JobApplication__c(
            JobId__c ='13454323244'
        );
        insert jobApp;
    }
    @isTest
    public static void AttachCompaniesToJobApplications_inputMap_successful(){
        Map<String,String> newMap = new Map<String, String>();
        newMap.put('13454323244', 'Golden company');
        Account company = [SELECT Id, Name FROM Account LIMIT 1];

        Test.startTest();
        System.enqueueJob(new AttachCompaniesToJobApplications(newMap));
        Test.stopTest();

        JobApplication__c updatedJobApp = [SELECT Company__c FROM JobApplication__c];
        System.assertEquals(company.Id, updatedJobApp.Company__c, 'Company field was updated');
    }
}