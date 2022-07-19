/**
 * Created by mgieron on 08.07.2022.
 */

public with sharing class WebinarListController {
    @AuraEnabled
    public static Webinar__c[] getPendingWebinars(String queryLimit){
        return [
                SELECT Name, Description__c, Cost__c, Status__c, Approval_Status__c
                FROM Webinar__c
                WHERE Approval_Status__c='Pending'
                LIMIT :Integer.valueOf(queryLimit)
        ];
    }

    @AuraEnabled
    public static void changeWebinarStatus(Id id, String newStatus){
        System.debug('aaa');
        Webinar__c w = [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Id=:id LIMIT 1];
        w.Approval_Status__c = newStatus;
        update w;
    }
}