/**
 * Created by mgieron on 06.07.2022.
 */

public with sharing class WebinarTriggerHandler {
    public static void handleBeforeInsert(List<Webinar__c> newWebinars) {
        for (Webinar__c webinar : newWebinars) {
            beforeInsertOrUpdateOperations(webinar);
        }
    }

    public static void handleBeforeUpdate(List<Webinar__c> newWebinars) {
        for (Webinar__c webinar : newWebinars) {
            beforeInsertOrUpdateOperations(webinar);
        }
    }

    private static void beforeInsertOrUpdateOperations(Webinar__c webinar) {
        if (isNumberOfParticipantsExceedingSeatNumber(webinar)) webinar.addError('Number of participants exceeds...');
        if (isCostBelow100Euro(webinar)) approveWebinar(webinar);
        if (isRejected(webinar)) cancel(webinar);
        if (!canStatusBePending(webinar) && isStatusPending(webinar)) webinar.addError('Status cannot be pending');
        updatePricePerParticipant(webinar);
    }

    private static Boolean isCostBelow100Euro(Webinar__c webinar) {
        return webinar.Cost__c < 100;
    }

    private static void approveWebinar(Webinar__c webinar) {
        webinar.Approval_Status__c = 'Approved';
    }

    private static Boolean isCancelled(Webinar__c webinar) {
        return webinar.Status__c == 'Canceled';
    }

    private static void rejectWebinar(Webinar__c webinar) {
        webinar.Approval_Status__c = 'Rejected';
    }

    private static void updatePricePerParticipant(Webinar__c webinar) {
        if (webinar.Cost__c == null || webinar.Number_of_Participants__c == null || webinar.Number_of_Participants__c == 0) {
            webinar.Price_per_Participant__c = 0;
        } else {
            webinar.Price_per_Participant__c = webinar.Cost__c / webinar.Number_of_Participants__c;
        }
    }

    private static Boolean isStatusPending(Webinar__c webinar) {
        return webinar.Approval_Status__c == 'Pending';
    }

    private static Boolean canStatusBePending(Webinar__c webinar) {
        return webinar.Status__c == 'New' || webinar.Status__c == 'Canceled';
    }

    private static Boolean isRejected(Webinar__c webinar) {
        return webinar.Approval_Status__c == 'Rejected';
    }

    private static void cancel(Webinar__c webinar) {
        webinar.Status__c = 'Canceled';
    }

    private static Boolean isNumberOfParticipantsExceedingSeatNumber(Webinar__c webinar) {
        return webinar.Number_of_Participants__c != null &&
                webinar.Total_Number_of_Seats__c != null &&
                (webinar.Number_of_Participants__c > webinar.Total_Number_of_Seats__c);
    }

    public static void handleAfterInsert(List<Webinar__c> webinars) {
        List<WebinarEvent__e> events = new List<WebinarEvent__e>();
        for (Webinar__c webinar : webinars) {
            events.add(new WebinarEvent__e());
        }
        EventBus.publish(events);
    }
}