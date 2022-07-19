/**
 * Created by mgieron on 14.07.2022.
 */

public with sharing class ChatterNotificationBatchClass implements Database.Batchable<SObject>{

    public void execute(Database.BatchableContext param1, List<Webinar_Team_Member__c> webinarMembers) {
        Id userId;
        String textMessage;
        for(Webinar_Team_Member__c webinarMember : webinarMembers){
            textMessage = 'KIND REMINDER! WEBINAR \'' + webinarMember.Related_Webinar__r.Name + '\' IN 2 HOURS! TEST TEST TEST TEST TEST 2';
            userId = webinarMember.Id;
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, userId,
                    ConnectApi.FeedElementType.FeedItem, textMessage);
        }
    }

    public void finish(Database.BatchableContext param1) {
    }

    public Iterable<SObject> start(Database.BatchableContext param1) {
        Datetime currDate = Datetime.now();
        return Database.getQueryLocator('SELECT Id, Related_Webinar__r.Name FROM Webinar_Member__c WHERE Related_Webinar__r.Start_Date__c > ' + currDate.addHours(2) + ' Related_Webinar__r.Start_Date__c < ' + currDate.addHours(3));
    }
}