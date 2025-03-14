public class JoobleJobScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        JoobleNewJobsFinder jobFinder = new JoobleNewJobsFinder();
        System.enqueueJob(jobFinder);
    }
}