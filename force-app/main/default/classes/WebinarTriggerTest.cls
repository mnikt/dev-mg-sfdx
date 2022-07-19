/**
 * Created by mgieron on 07.07.2022.
 */

@IsTest
private with sharing class WebinarTriggerTest {
    @TestSetup
    private static void setup() {
        Webinar__c webinar = TEST_DataFactory.createWebinar();
        webinar.Cost__c = 50;
        insert webinar;
        Webinar__c webinar2 = TEST_DataFactory.createWebinar();
        webinar.Cost__c = 150;
        webinar.Type__c = 'Internal';
        insert webinar2;
        Contact contact = new Contact(MailingStreet = 'XD', MailingCountry = 'Poland', MailingCity = 'Szczecin',
                Phone = '123456789', Email = 'cos@gmale.com', LastName='Gieron');
        insert contact;
        Webinar_Team_Member__c teamMember = new Webinar_Team_Member__c(Related_Webinar__r=webinar2);
        insert teamMember;
    }

    @IsTest
    private static void approveWebinarIfCostBelow100() {
        for (Webinar__c webinar : [SELECT Id, Cost__c, Approval_Status__c FROM Webinar__c WHERE Cost__c < 100]) {
            System.assertEquals(webinar.Approval_Status__c, 'Approved', 'OK');
        }
    }

    @IsTest
    private static void approveUpdatedWebinarIfCostBelow100() {
        for (Webinar__c webinar : [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Cost__c >= 100]) {
            System.assertNotEquals(webinar.Approval_Status__c, 'Approved', 'OK');
            webinar.Cost__c = 50;
            update webinar; // put to list before if more data
            System.assertEquals(webinar.Approval_Status__c, 'Approved', 'OK');
        }
    }

    @IsTest
    private static void notApproveWebinarIfCostNotBelow100() {
        for (Webinar__c webinar : [SELECT Id, Approval_Status__c FROM Webinar__c WHERE Cost__c >= 100]) {
            System.assertNotEquals(webinar.Approval_Status__c, 'Approved', 'OK');
        }
    }

    @IsTest
    private static void cancelRejectedWebinar() {
        for (Webinar__c webinar : [SELECT Id, Approval_Status__c, Status__c FROM Webinar__c]) {
            webinar.Approval_Status__c = 'Rejected';
            webinar.Status__c = 'New';
            update webinar;
            System.assertEquals(webinar.Status__c, 'Canceled');
        }
    }

    @IsTest
    private static void cannotAddContactToInternalWebinar() {
        Id contactId = [SELECT Id FROM Contact][0].Id;
        for (Webinar_Team_Member__c teamMember : [SELECT Id, Related_Contact__c FROM Webinar_Team_Member__c WHERE Related_Webinar__r.Type__c != 'External']) {
            System.assertEquals(teamMember.Related_Contact__c, null);
            teamMember.Related_Contact__c = contactId;
            Database.SaveResult saveResult = Database.update(teamMember, false);
            System.assertEquals(saveResult.getErrors()[0].getMessage(), 'Contacts can be only added to external webinars.');
        }
    }

}