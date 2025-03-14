@isTest
public class TestDayBeforeInterviewReminder {
    @TestSetup
    static void setup(){
        Contact hrManager = new Contact(
            LastName = 'Gold',
            Email = 'johngold@goldy.com.au.com'
        );
        insert hrManager;
        JobApplication__c jobApp = new JobApplication__c(
            Name = 'First'
        );
        insert jobApp;
        User owner = new User(
            UserName = 'john@goldy.com.au.com',
            Email = 'john@goldy.com.au',
            FirstName = 'John',
            LastName = 'Gold',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            Alias = 'Alias1',
            Title = 'Title1'
        );
        insert owner;
        Interview__c interview = new Interview__c(
            Interviewer__c = hrManager.Id,
            JobApplication__c = jobApp.Id,
            Type__c = 'Group',
            Name = 'First',
            OwnerId = owner.Id
        );
        insert interview;
        
    }
    @isTest
    public static void DayBeforeInterviewReminder_setTomorrow_successfull(){
        Interview__c interview = [SELECT Id FROM Interview__c LIMIT 1];
        interview.InterviewDate__c = System.today().addDays(1);
        update interview;

        Test.startTest();
        DayBeforeInterviewReminder batchSender = new DayBeforeInterviewReminder();
        Database.executeBatch(batchSender);
        Test.stopTest();

        List<EmailMessage> emails = [SELECT Id FROM EmailMessage];
        System.assertEquals(1, emails.size(), 'Reminder was sent');

    }
    @isTest
    public static void DayBeforeInterviewReminder_removeHRManagerEmail_successfull(){
        Interview__c interview = [SELECT Id FROM Interview__c LIMIT 1];
        interview.InterviewDate__c = System.today().addDays(1);
        update interview;

        Contact hrmanager = [SELECT Email FROM Contact LIMIT 1];
        hrmanager.Email = '';
        update hrmanager;

        Test.startTest();
        DayBeforeInterviewReminder batchSender = new DayBeforeInterviewReminder();
        Database.executeBatch(batchSender);
        Test.stopTest();

        List<ErrorLog__c> errors = [SELECT Id FROM ErrorLog__c];
        System.assertEquals(1, errors.size(), 'Reminder wasnt sent');

    }
    @isTest
    static void DayBeforeInterviewReminderScheduler_scheduling_success() {       
        Test.startTest();
        
        String cronExp = '0 0 0 ? * * *'; // Daily at midnight
        String jobName = 'DayBeforeInterviewReminderScheduler';
        DayBeforeInterviewReminderScheduler scheduler = new DayBeforeInterviewReminderScheduler();
        String jobId = System.schedule(jobName, cronExp, scheduler);
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered 
                        FROM CronTrigger 
                        WHERE Id = :jobId];
        System.assertEquals(cronExp, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
    }
}