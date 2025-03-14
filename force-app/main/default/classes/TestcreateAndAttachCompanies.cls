@isTest
public class TestcreateAndAttachCompanies {
    @isTest
    public static void CreateAndAttachCompanies_inputMap_successful(){
        Map<String,String> newMap = new Map<String, String>();
        newMap.put('13454323244', 'Golden company');

        Test.startTest();
        System.enqueueJob(new CreateAndAttachCompanies(newMap));
        Test.stopTest();

        List<Account> companies = [SELECT Id FROM Account];
        System.assertEquals(1, companies.size(), 'Company was inserted');
    }
}