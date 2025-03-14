public class jobApplicationTriggerHandler {
    static final String SAVED_STATUS = 'Saved';
    static final String APPLYING_STATUS = 'Applying';
    static final String APPLIED_STATUS = 'Applied';
    static final String INTERVIEWING_STATUS = 'Interviewing';
    static final String NEGOTIATING_STATUS = 'Negotiating';
    static final String ACCEPTED_STATUS = 'Accepted';
    static final String CLOSED_STATUS = 'Closed';

    public static void createTask(List<JobApplication__c> newList, Map<Id, JobApplication__c> oldMap){
        List<Task> tasksList = new List<Task>();
        for (JobApplication__c jobApp : newList) {
            if (String.isNotBlank(jobApp.Status__c) && jobApp.Status__c != oldMap.get(jobApp.Id).Status__c) {
                if (jobApp.Status__c == SAVED_STATUS) {
                    Task task = new Task(
                        ActivityDate = System.today().addDays(2),
                        Subject = 'Task on '+ SAVED_STATUS + ' Status',
                        Priority = 'Low',
                        WhatId = jobApp.Id,
                        WhoId = jobApp.PrimaryContact__c,
                        Description = '1. Check if the job description aligns with your interests and values' + '\n' +
                                        '2. Review the highlighted skills to see if the role is a good fit' + '\n' +
                                        '3. Research the company or role and mark your excitement level'
                    );
                    tasksList.add(task);
                } else if (jobApp.Status__c == APPLYING_STATUS) {
                    Task task = new Task(
                        ActivityDate = System.today().addDays(2),
                        Subject = 'Task on '+ APPLYING_STATUS + ' Status',
                        Priority = 'Normal',
                        WhatId = jobApp.Id,
                        WhoId = jobApp.PrimaryContact__c,
                        Description = '1. Find and research someone who works at the company and add them as a contact' + '\n' +
                                        '2. Set up an informational interview to learn more about the role/company' + '\n' +
                                        '3. Identify potential referrals to help get your application on the top of the pile' + '\n' +
                                        '4. Customize your work achievements using the job description keywords' + '\n' +
                                        '5. Submit your application on the company website if possible'
                    );
                    tasksList.add(task);
                } else if (jobApp.Status__c == APPLIED_STATUS) {
                    Task task = new Task(
                        ActivityDate = System.today().addDays(2),
                        Subject = 'Task on '+ APPLIED_STATUS + ' Status',
                        Priority = 'Normal',
                        WhatId = jobApp.Id,
                        WhoId = jobApp.PrimaryContact__c,
                        Description = '1. Reach out to the hiring manager or recruiter' + '\n' +
                                        '2. Follow up on your application via email weekly' + '\n' +
                                        '3. Continue identifying and saving similar job opportunities' + '\n' +
                                        '4. Set up weekly networking calls to explore similar companies/roles'
                    );
                    tasksList.add(task);
                } else if (jobApp.Status__c == INTERVIEWING_STATUS) {
                    Task task = new Task(
                        ActivityDate = System.today().addDays(3),
                        Subject = 'Task on '+ INTERVIEWING_STATUS + ' Status',
                        Priority = 'High',
                        WhatId = jobApp.Id,
                        WhoId = jobApp.PrimaryContact__c,
                        Description = '1. Prepare your blurb or “tell me about yourself” response' + '\n' +
                                        '2. Practice answering behavioral interview questions' + '\n' +
                                        '3. Research the company and your interviewers' + '\n' +
                                        '4. Set up your virtual interview space and test your tech' + '\n' +
                                        '5. Send thank you emails within 24 hours'
                    );
                    tasksList.add(task);
                } else if (jobApp.Status__c == NEGOTIATING_STATUS) {
                    Task task = new Task(
                        ActivityDate = System.today().addDays(4),
                        Subject = 'Task on '+ NEGOTIATING_STATUS + ' Status',
                        Priority = 'High',
                        WhatId = jobApp.Id,
                        WhoId = jobApp.PrimaryContact__c,
                        Description = '1. Research your market value and know your numbers' + '\n' +
                                        '2. Prepare your negotiation scripts' + '\n' +
                                        '3. Evaluate your offer and decline or accept'
                    );
                    tasksList.add(task);
                } else if (jobApp.Status__c == ACCEPTED_STATUS) {
                    Task task = new Task(
                        ActivityDate = System.today().addDays(4),
                        Subject = 'Task on '+ ACCEPTED_STATUS + ' Status',
                        Priority = 'High',
                        WhatId = jobApp.Id,
                        WhoId = jobApp.PrimaryContact__c,
                        Description = '1. Plan your resignation if applicable' + '\n' +
                                        '2. Take some time to relax and recharge' + '\n' +
                                        '3. Prepare for your first day of onboarding'
                    );
                    tasksList.add(task);
                } else if (jobApp.Status__c == CLOSED_STATUS) {
                    Task task = new Task(
                        ActivityDate = System.today().addDays(4),
                        Subject = 'Task on '+ CLOSED_STATUS + ' Status',
                        Priority = 'Low',
                        WhatId = jobApp.Id,
                        WhoId = jobApp.PrimaryContact__c,
                        Description = '1. Send a follow-up email thanking the interviewer and asking for feedback' + '\n' +
                                        '2. Review your notes and reflect on areas of improvement'
                    );
                    tasksList.add(task);
                }
            }
        }
        if (!tasksList.isEmpty()) {
            insert tasksList;
        }
    }
    public static void assignPrimaryContact(List<JobApplication__c> newList, Map<Id, JobApplication__c> oldMap){
        Set<Id> jobAppsWithoutPrimContact = new Set<Id>();
        Set<Id> companiesSet = new Set<Id>();
        Map<Id, Id> jobAppToContact = new Map<Id, Id>();
        Map<Id, Id> companyToContact = new Map<Id, Id>();

        for (JobApplication__c jobApp : newList) {
            JobApplication__c oldJobApplication = (oldMap != null) ? oldMap.get(jobApp.Id) : null;
            if (jobApp.PrimaryContact__c == null) {
                if (jobApp.Company__c != null) {
                    companiesSet.add(jobApp.Company__c);
                }
                if (oldJobApplication != null) {
                    jobAppsWithoutPrimContact.add(jobApp.Id);
                }
            }
        }
        if (!companiesSet.isEmpty()) {
            for (AccountContactRelation acr : [SELECT AccountId, ContactId FROM AccountContactRelation WHERE AccountId IN : companiesSet]) {
                companyToContact.put(acr.AccountId, acr.ContactId);
            }
        }
        if (!jobAppsWithoutPrimContact.isEmpty()) {
            for (JobApplicationContactRelation__c jobAppConRel : [SELECT JobApplication__c, Contact__c FROM JobApplicationContactRelation__c WHERE JobApplication__c IN : jobAppsWithoutPrimContact]) {
                jobAppToContact.put(jobAppConRel.JobApplication__c, jobAppConRel.Contact__c);
            }
        } 
        for (JobApplication__c jobAppWOPC : newList) {
            Id jobAppContactId = jobAppToContact.get(jobAppWOPC.Id);
            Id companyContactId = companyToContact.get(jobAppWOPC.Company__c);
            JobApplication__c oldJobApplication = (oldMap != null) ? oldMap.get(jobAppWOPC.Id) : null;
            if (oldJobApplication == null) {
                if (companyContactId != null) {
                    jobAppWOPC.PrimaryContact__c = companyContactId;
                    continue;
                }
            } else {
                if (jobAppContactId != null) {
                    jobAppWOPC.PrimaryContact__c = jobAppContactId;
                    continue;
                }
                if (companyContactId != null) {
                    jobAppWOPC.PrimaryContact__c = companyContactId;
                    continue;
                }
            }
        }
    }
}