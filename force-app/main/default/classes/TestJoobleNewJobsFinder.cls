@isTest
public class TestJoobleNewJobsFinder {
    @TestSetup
    static void setup(){

    }
    @isTest
    static void JoobleNewJobsFinder_getDataFromMockRequest_successfull(){
        Test.setMock(HttpCalloutMock.class, new DummyJSONCalloutMockGenerator());

        Test.startTest();
		JoobleNewJobsFinder defaultJobFinder = new JoobleNewJobsFinder(); 
        System.enqueueJob(defaultJobFinder);
        Test.stopTest();

        JobApplication__c jobApp = [SELECT PositionTitle__c FROM JobApplication__c LIMIT 1];
        System.assertEquals('Senior Software Engineer - Onsite', jobApp.PositionTitle__c, 'Proper JobApp is inserted');
    }
}