global class DayBeforeInterviewReminder implements Database.Batchable<SObject>, Database.Stateful{
    Date dayBeforeInterview;
    String DayBeforeInterviewReminderTemplateName;
    Id DayBeforeInterviewReminderTemplateId;

    global DayBeforeInterviewReminder(){
        this.dayBeforeInterview = System.today().addDays(1);
        this.DayBeforeInterviewReminderTemplateId = [SELECT Id
                                                        FROM EmailTemplate
                                                        WHERE Name =: System.Label.DayBeforeInterviewReminderTemplateName LIMIT 1].Id;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([
            SELECT Owner.Email, Interviewer__c, JobApplication__c
            FROM Interview__c
            WHERE InterviewDate__c =: dayBeforeInterview
        ]);
    }
    global void execute(Database.BatchableContext BC, List<Interview__c> scope){
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        List<ErrorLog__c> errorLogs = new List<ErrorLog__c>();
        
        for (Interview__c interview : scope) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{interview.Owner.Email});
            email.setTargetObjectId(interview.Interviewer__c);
            email.setTemplateId(DayBeforeInterviewReminderTemplateId);
            email.setWhatId(interview.Id);
            email.setSaveAsActivity(TRUE);
            emailList.add(email);
        }
        if (!emailList.isEmpty()) {
            try {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList, false);
                for (Messaging.SendEmailResult result : results) {
                    if (!result.isSuccess()) {
                        for (Messaging.SendEmailError err : result.getErrors()) {
                            ErrorLog__c error = new ErrorLog__c();
                            error.ClassName__c = 'DayBeforeInterviewReminder';
                            error.ErrorMessage__c = err.getMessage();
                            errorLogs.add(error);
                        }
                    }
                } 
            } catch (Exception ex) {
                ErrorLog__c error = new ErrorLog__c();
                error.ClassName__c = 'DayBeforeInterviewReminder';
                error.ErrorMessage__c = ex.getMessage();
                errorLogs.add(error);
            }
        }
        if (!errorLogs.isEmpty()) {
            insert errorLogs;
        }
    }
    global void finish(Database.BatchableContext BC){
        DayBeforeInterviewReminder newBatch = new DayBeforeInterviewReminder();
    }
}