/**
 * Created by mgieron on 13.07.2022.
 */

import { LightningElement, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getLatestQuestionnaire from '@salesforce/apex/WebinarController.getLatestQuestionnaire';
import QUESTIONNAIRE from '@salesforce/schema/Questionnaire__c';
import NAME_FIELD from '@salesforce/schema/Questionnaire__c.Name';

export default class NewestQuestionnaire extends LightningElement {
    @api webinarId;
    questionnaireId = null;
    objectApiName = QUESTIONNAIRE;
    name = NAME_FIELD;

    connectedCallback(){
        if(this.webinarId){
            getLatestQuestionnaire({'webinarId': this.webinarId})
            .then(result =>{
                this.questionnaireId = result;
            })
            .catch(error => console.error(error));
        }
    }
}