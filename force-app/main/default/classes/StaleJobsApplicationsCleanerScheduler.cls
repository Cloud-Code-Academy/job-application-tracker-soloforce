public class StaleJobsApplicationsCleanerScheduler implements Schedulable{
    public void execute(SchedulableContext sc){
        Database.executeBatch(new StaleJobsApplicationsCleaner());
    }
}