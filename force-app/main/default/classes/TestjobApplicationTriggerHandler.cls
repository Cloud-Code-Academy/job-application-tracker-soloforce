@isTest
public class TestjobApplicationTriggerHandler {
    @TestSetup
    static void setup(){
        final String SAVED_STATUS = 'Saved';
        final String APPLYING_STATUS = 'Applying';
        final String APPLIED_STATUS = 'Applied';
        final String INTERVIEWING_STATUS = 'Interviewing';
        final String NEGOTIATING_STATUS = 'Negotiating';
        final String ACCEPTED_STATUS = 'Accepted';
        final String CLOSED_STATUS = 'Closed';
        JobApplication__c jobAppRec = new JobApplication__c(
            Name = 'First'
        );
        insert jobAppRec;

        Account company = new Account();
        company.Name = 'Coffee';
        insert company;

        Contact hrManager = new Contact(
            LastName = 'Gold',
            AccountId = company.Id
        );
        insert hrManager;

    }
    @isTest
    public static void createTask_setSavedStatus_successfull(){
        JobApplication__c jobRecord = [SELECT Id, Status__c FROM JobApplication__c LIMIT 1];
        jobRecord.Status__c = 'Saved';

        Test.startTest();
        update jobRecord;
        Test.stopTest();

        Task newTask = [SELECT Subject FROM Task LIMIT 1];
        System.assertEquals(newTask.Subject.contains('Saved'), true, 'New task is created');
    }
    @isTest
    public static void createTask_setApplyingStatus_successfull(){
        JobApplication__c jobRecord = [SELECT Id, Status__c FROM JobApplication__c LIMIT 1];
        jobRecord.Status__c = 'Applying';

        Test.startTest();
        update jobRecord;
        Test.stopTest();

        Task newTask = [SELECT Subject FROM Task LIMIT 1];
        System.assertEquals(newTask.Subject.contains('Applying'), true, 'New task is created');
    }
    @isTest
    public static void createTask_setAppliedStatus_successfull(){
        JobApplication__c jobRecord = [SELECT Id, Status__c FROM JobApplication__c LIMIT 1];
        jobRecord.Status__c = 'Applied';

        Test.startTest();
        update jobRecord;
        Test.stopTest();

        Task newTask = [SELECT Subject FROM Task LIMIT 1];
        System.assertEquals(newTask.Subject.contains('Applied'), true, 'New task is created');
    }
    @isTest
    public static void createTask_setInterviewingStatus_successfull(){
        JobApplication__c jobRecord = [SELECT Id, Status__c FROM JobApplication__c LIMIT 1];
        jobRecord.Status__c = 'Interviewing';

        Test.startTest();
        update jobRecord;
        Test.stopTest();

        Task newTask = [SELECT Subject FROM Task LIMIT 1];
        System.assertEquals(newTask.Subject.contains('Interviewing'), true, 'New task is created');
    }
    @isTest
    public static void createTask_setNegotiatingStatus_successfull(){
        JobApplication__c jobRecord = [SELECT Id, Status__c FROM JobApplication__c LIMIT 1];
        jobRecord.Status__c = 'Negotiating';

        Test.startTest();
        update jobRecord;
        Test.stopTest();

        Task newTask = [SELECT Subject FROM Task LIMIT 1];
        System.assertEquals(newTask.Subject.contains('Negotiating'), true, 'New task is created');
    }
    @isTest
    public static void createTask_setAcceptedStatus_successfull(){
        JobApplication__c jobRecord = [SELECT Id, Status__c FROM JobApplication__c LIMIT 1];
        jobRecord.Status__c = 'Accepted';

        Test.startTest();
        update jobRecord;
        Test.stopTest();

        Task newTask = [SELECT Subject FROM Task LIMIT 1];
        System.assertEquals(newTask.Subject.contains('Accepted'), true, 'New task is created');
    }
    @isTest
    public static void createTask_setClosedStatus_successfull(){
        JobApplication__c jobRecord = [SELECT Id, Status__c FROM JobApplication__c LIMIT 1];
        jobRecord.Status__c = 'Closed';

        Test.startTest();
        update jobRecord;
        Test.stopTest();

        Task newTask = [SELECT Subject FROM Task LIMIT 1];
        System.assertEquals(newTask.Subject.contains('Closed'), true, 'New task is created');
    }
    @isTest
    public static void createTask_setNullStatus_successfull(){
        JobApplication__c jobApp = new JobApplication__c(
            Name ='Second'
        );
        
        Test.startTest();
        insert jobApp;
        Test.stopTest();

        List<Task> newTasks = [SELECT Subject FROM Task];
        System.assertEquals(0, newTasks.size(), 'New task wasnt created');
    }
    @isTest
    public static void assignPrimaryContact_setNullStatus_successfull(){
        Account company = [SELECT Id FROM Account LIMIT 1];
        Contact hrManager = [SELECT Id FROM Contact LIMIT 1];
        JobApplication__c jobApp = new JobApplication__c(
            Name ='Second',
            Company__c = company.Id
        );
        
        Test.startTest();
        insert jobApp;
        Test.stopTest();

        JobApplication__c updatedJobApp = [SELECT PrimaryContact__c FROM JobApplication__c WHERE Name =: 'Second'];
        System.assertEquals(hrManager.Id, updatedJobApp.PrimaryContact__c, 'Primary Contact is assigned');
    }
}