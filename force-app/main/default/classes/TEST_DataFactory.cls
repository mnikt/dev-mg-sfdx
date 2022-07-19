/**
 * Created by mgieron on 07.07.2022.
 */


@isTest
public class TEST_DataFactory {
    public static Account createTestAccount() {
        Account account = new Account(Name = 'accName', Active__c = 'Yes');
        return account;
    }
    public static List<Opportunity> createTestOpportunity() {
        List<Opportunity> testOpportunities = new List<Opportunity>();
        for (Integer i = 0; i < 4; i++) {
            testOpportunities.add(new Opportunity(Name = 'oppName' + i, StageName = 'stagename', CloseDate = Date.today()));
        }
        return testOpportunities;
    }
    public static Webinar__c createWebinar(){
        return new Webinar__c();
    }
}