public class DayBeforeInterviewReminderScheduler implements Schedulable{
    public void execute(SchedulableContext sc){
        Database.executeBatch(new DayBeforeInterviewReminder());
    }
}