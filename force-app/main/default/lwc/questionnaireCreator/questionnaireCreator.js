/**
 * Created by mgieron on 12.07.2022.
 */

import { LightningElement, api, wire } from 'lwc';
import createQuestionnaire from '@salesforce/apex/QuestionnaireController.createQuestionnaire';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import { NavigationMixin } from 'lightning/navigation';

export default class QuestionnaireCreator extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName = 'Questionnaire__c';
    @api toastSuccessMessage = "";
    @api userId = ID;

    isTableVisible = false;
    isWebinarRecommended = true;
    didUserAttend = true;
    title = 'Hi!'

    @wire(getRecord, {recordId: ID, fields: NAME_FIELD})
    wiredRecord({ error, data }) {
        if(data){
             this.title =`Hi ${data.fields.Name.value}! Share your feedback with us!`;
         }
    }

    onFormSubmit = (event) => {
        event.preventDefault();
        const formData = new FormData(event.target);
        formData.append('didUserAttend', this.didUserAttend);
        formData.append('wouldRecommend', this.isWebinarRecommended);
        this.saveQuestionnaire(Object.fromEntries(formData));
    }

    saveQuestionnaire = (data) => {
        createQuestionnaire(data)
        .then(result => {
            console.log(result);
            this.successHandler(result);
        })
        .catch(error => console.error(error));
    }

    recommendationFieldChange = (event) => {
        this.isWebinarRecommended = event.target.checked;
    }

    attendanceFieldChange = (event) => {
        this.didUserAttend = event.target.checked;
    }

    successHandler = (id) => {
        this.showSuccessAddToast();
        this.navigateToRecordPage(id);
    }

    showSuccessAddToast() {
        const evt = new ShowToastEvent({
            title: 'Adding Success',
            message: this.toastSuccessMessage,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    navigateToRecordPage(id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: id,
                actionName: 'view',
            },
        });
    }

    showTable = () => {
        this.isTableVisible = true;
    }

    hideTable = () => {
        this.isTableVisible = false;
    }
}