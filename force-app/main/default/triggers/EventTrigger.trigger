trigger EventTrigger on Event (before insert) {
    switch on Trigger.OperationType{
        when BEFORE_INSERT{
            EventTriggerHandler.meetingValidation(Trigger.new);
        }
    }
}
