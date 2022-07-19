/**
 * Created by mgieron on 13.07.2022.
 */

public with sharing class WebinarController {
    @AuraEnabled
    public static Id createWebinar(String name, String type, String cost, String price) {
        Webinar__c webinar = new Webinar__c(
                Name = name,
                Type__c = type,
                Cost__c = Integer.valueOf(cost),
                Price_per_Participant__c = Integer.valueOf(price));
        insert webinar;
        return webinar.Id;
    }

    @AuraEnabled
    public static String getLatestQuestionnaire(String webinarId){
        return [SELECT Id FROM Questionnaire__c WHERE Webinar__c=:webinarId ORDER BY CreatedDate DESC LIMIT 1].Id;
    }
}