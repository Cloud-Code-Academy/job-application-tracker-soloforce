public class createAndAttachCompanies implements Queueable{

    private Map<String, String> companyNamesJobIdsMap;

    public CreateAndAttachCompanies(Map<String, String> companyNamesJobIds) {
        this.companyNamesJobIdsMap = companyNamesJobIds;
    }
    
    public void execute(QueueableContext context) {
        Map<String, Id> companyMap = new Map<String, Id>();
        List<Account> companiesForInsert = new List<Account>();
        for (Account acc : [SELECT Id, Name FROM Account WHERE Name IN: companyNamesJobIdsMap.values()]) {
            companyMap.put(acc.Name, acc.Id);
        }
        for (String  name : companyNamesJobIdsMap.values()) {
            if (!companyMap.containsKey(name) && name != null) {
                Account newCompany = new Account();
                newCompany.Name = name;
                companiesForInsert.add(newCompany);
            }
        }
        if (!companiesForInsert.isEmpty()) {
            insert companiesForInsert;
        }
        if (!Test.isRunningTest()) {
            System.enqueueJob(new AttachCompaniesToJobApplications(companyNamesJobIdsMap));
        }
        
    }
}