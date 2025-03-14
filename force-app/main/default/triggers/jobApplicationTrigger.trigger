trigger jobApplicationTrigger on JobApplication__c (before insert, before update, after insert, after update) {
    switch on Trigger.OperationType {
        when BEFORE_INSERT{
            jobApplicationTriggerHandler.assignPrimaryContact(Trigger.new, null);
        }
        when BEFORE_UPDATE{
            jobApplicationTriggerHandler.assignPrimaryContact(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            jobApplicationTriggerHandler.createTask(Trigger.new, Trigger.oldMap);
        }
    }
}