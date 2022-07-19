/**
 * Created by mgieron on 14.07.2022.
 */

public with sharing class AutoNotifications implements Schedulable {

    public void execute(SchedulableContext schedulableContext) {
        List<Webinar__c> webinars = getWebinars();

        for (Webinar__c webinar : webinars) {
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), webinar.Id, ConnectApi.FeedElementType.FeedItem, webinar.Name + ' starts soon!');
        }
    }

    private List<Webinar__c> getWebinars() {
        Datetime current = Datetime.now();
        Datetime inTwoHours = Datetime.now().addHours(2);

        return [
                SELECT Id, Name, (SELECT Id FROM Webinar_Team_Members__r)
                FROM Webinar__c
                WHERE Start_Date__c >= :current AND Start_Date__c <= :inTwoHours
        ];
    }
}