@isTest
public class TestEventTriggerHandler {
    @TestSetup
    static void setup(){
        Event meeting = new Event(
            Subject = 'Meeting',
            StartDateTime = DateTime.newInstance(2025, 3, 15, 0, 0, 0),
            EndDateTime = DateTime.newInstance(2025, 3, 15, 0, 10, 0)
        );
        insert meeting;
    }
    @isTest
    public static void createTask_setSavedStatus_successfull(){
        Event meeting = new Event(
            Subject = 'Meeting',
            StartDateTime = DateTime.newInstance(2025, 3, 15, 0, 0, 0),
            EndDateTime = DateTime.newInstance(2025, 3, 15, 0, 10, 0)
        );

    Test.startTest();
    Boolean ExceptionThrown = false;
    try {
        insert meeting;
    } catch (Exception ex) {
        ExceptionThrown = true;
        Boolean expectedExceptionThrown =  (ex.getMessage().contains('Please choose another time, this time is booked for another meeting')) ? true : false; 
        System.assertEquals(true, expectedExceptionThrown, ex.getMessage());
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception was thrown');
    }
}