/**
 * Created by mgieron on 06.07.2022.
 */

public with sharing class WebinarTeamMemberTriggerHandler {
    public static void handleBeforeInsertOrUpdate(List<Webinar_Team_Member__c> newWebinarTeamMembers) {
        Map<Id, Webinar__c> mapOfWebinars = getMapOfTeamMembersWithWebinarType(newWebinarTeamMembers);
        List<Webinar_Team_Member__c> possibleDuplicates = getPossibleDuplicates(newWebinarTeamMembers);

        for (Webinar_Team_Member__c teamMember : newWebinarTeamMembers) {
            if (isMemberContact(teamMember) && isMemberUser(teamMember)) {
                teamMember.addError('Webinar member can be Contact OR User.');
            }
            if (!isWebinarExternal(mapOfWebinars.get((String) teamMember.get('Related_Webinar__c'))) && isMemberContact(teamMember)) {
                teamMember.addError('Contacts can be only added to external webinars.');
            }

            if (isRejected(teamMember) && !isCommentFieldFilled(teamMember)) teamMember.addError('Comment field cannot be empty');
            if (isDuplicated(teamMember, possibleDuplicates)) teamMember.addError('Duplicated value');
        }
    }

    private static Boolean isMemberUser(Webinar_Team_Member__c teamMember) {
        return teamMember.Related_User__c != null;
    }

    private static Boolean isMemberContact(Webinar_Team_Member__c teamMember) {
        return teamMember.Related_Contact__c != null;
    }

    private static Boolean isWebinarExternal(Webinar__c webinar) {
        return webinar != null && webinar.Type__c == 'External';
    }

    private static Map<Id, Webinar__c> getMapOfTeamMembersWithWebinarType(List<Webinar_Team_Member__c> teamMembers) {
        Set<Id> teamMembersIds = new Set<Id>();
        Map<Id, Webinar__c> mapOfWebinars = new Map<Id, Webinar__c>();
        for(Webinar_Team_Member__c teamMember : teamMembers) teamMembersIds.add(teamMember.Id);
        List<Webinar__c> webinars = [SELECT Id, Type__c FROM Webinar__c WHERE Id IN :teamMembersIds];
        mapOfWebinars.putAll(webinars);
        return mapOfWebinars;
    }

    private static Boolean isRejected(Webinar_Team_Member__c teamMember) {
        return teamMember.Status__c == 'Rejected';
    }

    private static Boolean isCommentFieldFilled(Webinar_Team_Member__c teamMember) {
        return teamMember.Comments__c != null && teamMember.Comments__c != '';
    }

    private static List<Webinar_Team_Member__c> getPossibleDuplicates(List<Webinar_Team_Member__c> teamMembers) {
        Set<Id> contactsId = new Set<Id>();
        Set<Id> webinarsId = new Set<Id>();
        Set<Id> usersId = new Set<Id>();

        for (Webinar_Team_Member__c teamMember : teamMembers)
        {
            contactsId.add(teamMember.Related_Contact__c);
            webinarsId.add(teamMember.Related_Webinar__c);
            usersId.add(teamMember.Related_User__c);
        }

        return [SELECT Id, Related_Webinar__c, Related_User__c, Related_Contact__c FROM Webinar_Team_Member__c
        WHERE Related_Webinar__c IN :webinarsId AND (Related_User__c IN :usersId OR Related_Contact__c IN :contactsId)];
    }

    private static Boolean isDuplicated(Webinar_Team_Member__c teamMember, List<Webinar_Team_Member__c> duplicates) {
        for (Webinar_Team_Member__c duplicate : duplicates) {
            if (duplicate.Related_Webinar__c == teamMember.Related_Webinar__c && teamMember.Related_Webinar__c != null &&
                    (
                            (duplicate.Related_Contact__c == teamMember.Related_Contact__c && duplicate.Related_Contact__c != null)
                    ||
                            (duplicate.Related_User__c == teamMember.Related_User__c && duplicate.Related_User__c != null)
                    )
            ) return true;
        }
        return false;
    }

}