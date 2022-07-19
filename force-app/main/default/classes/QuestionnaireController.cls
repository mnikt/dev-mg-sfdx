/**
 * Created by mgieron on 12.07.2022.
 */

public with sharing class QuestionnaireController {
    @AuraEnabled
    public static Id createQuestionnaire(String age, String didUserAttend, String feedbackComment, String score, String webinarId, String wouldRecommend) {
        Questionnaire__c q = new Questionnaire__c(Name = 'Example',
                Age__c = Integer.valueOf(age),
                didUserAttend__c = Boolean.valueOf(didUserAttend),
                Feedback_comments__c = feedbackComment,
                Score__c = Integer.valueOf(score),
                Webinar__c = webinarId,
                wouldRecommend__c = Boolean.valueOf(wouldRecommend));
        try {
            insert q;
            return q.Id;
        } catch (Exception e) {
            return null;
        }
    }

    @AuraEnabled(Cacheable=true)
    public static List<Questionnaire__c> getUsersQuestionnaires(String userId) {
        return [
                SELECT Id, Name, Score__c, Feedback_comments__c, didUserAttend__c
                FROM Questionnaire__c
                WHERE CreatedById = :userId
        ];
    }
}