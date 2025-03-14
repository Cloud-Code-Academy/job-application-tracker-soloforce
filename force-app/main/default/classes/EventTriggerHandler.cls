public class EventTriggerHandler {
    public static void meetingValidation(List<Event> newList){
        final String MEETING_SUBJECT = 'Meeting';
        final String ERROR_MESSAGE = 'Please choose another time, this time is booked for another meeting';
        List<Datetime> meetingStartTimes = new List<Datetime>();
        List<Datetime> meetingEndTimes = new List<Datetime>();
        List<Integer> unixStartTimes = new List<Integer>();
        List<Integer> unixEndTimes = new List<Integer>();
        Map<Integer, Integer> startToEndTimes = new Map<Integer, Integer>();

        for (Event meeting : newList) {
            if (meeting.Subject == MEETING_SUBJECT) {
                meetingStartTimes.add(meeting.StartDateTime);
                meetingEndTimes.add(meeting.EndDateTime);
            }
        }
        for (Event sameTimeMeeting : [SELECT StartDateTime, EndDateTime FROM Event WHERE (StartDateTime IN: meetingStartTimes) OR (EndDateTime IN: meetingEndTimes)]) {
            Integer unixStartTimeInHours = (sameTimeMeeting.StartDateTime.getTime() / (1000.0 * 60.0 * 60.0)).intValue();
            Integer unixEndTimeInHours = (sameTimeMeeting.EndDateTime.getTime() / (1000.0 * 60.0 * 60.0)).intValue();
            startToEndTimes.put(unixStartTimeInHours, unixEndTimeInHours);

        }
        for (Event meetingForCheck : newList) {
            Integer unixStartTime = (meetingForCheck.StartDateTime.getTime() / (1000.0 * 60.0 * 60.0)).intValue();
            Integer unixEndTime = (meetingForCheck.EndDateTime.getTime() / (1000.0 * 60.0 * 60.0)).intValue();
            Boolean timeIsWithin = false;

            for (Integer startTimeUnixHours : startToEndTimes.keySet()) {
                if (unixStartTime >= startTimeUnixHours && unixStartTime <= startToEndTimes.get(startTimeUnixHours)) {
                    timeIsWithin = true;
                    continue;
                }
                if (unixEndTime >= startTimeUnixHours && unixEndTime <= startToEndTimes.get(startTimeUnixHours)) {
                    timeIsWithin = true;
                    continue;
                }
            }
            if (timeIsWithin == true) {
                meetingForCheck.addError(ERROR_MESSAGE);
            }

        }
    }
}