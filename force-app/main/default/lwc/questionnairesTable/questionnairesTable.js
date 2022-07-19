/**
 * Created by mgieron on 13.07.2022.
 */

import { LightningElement, api } from 'lwc';
import getUsersQuestionnaires from '@salesforce/apex/QuestionnaireController.getUsersQuestionnaires';

export default class QuestionnairesTable extends LightningElement {
    @api userId;
    questionnaires = [];
    columns = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Name', fieldName: 'Name'},
        { label: 'Score', fieldName: 'Score__c', type: 'number'},
        { label: 'Feedback comment', fieldName: 'Feedback_comments__c'},
        { label: 'Attendance', fieldName: 'didUserAttend__c', type: 'boolean'},
    ];

    populateTable = () => {
       getUsersQuestionnaires({userId: this.userId})
       .then(result => this.questionnaires = result)
       .catch(error => console.error(error));
    }

    connectedCallback(){
        this.populateTable();
    }
}