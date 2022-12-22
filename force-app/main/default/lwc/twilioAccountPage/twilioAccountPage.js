import { LightningElement,track,api,wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
import sendGoldSMS from '@salesforce/apex/twilioAccountPageController.sendGoldNotifyMessageLWC';


export default class TwilioAccountPage extends LightningElement {
    //setting up useful variables for the LWC
    @api recordId;
    @track buttonDisabled = true;
    @track inputMessage;

    //getting the record name through "recordId" and "wire" function
    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_NAME] })
    account;

    //populate "name" variable
    get name() {
        return getFieldValue(this.account.data, ACCOUNT_NAME);
    }
    
    //enablig sending button when the "messageBox" value is different from "NULL" on lighting input area change
    handleChange(){
        this.inputMessage = this.template.querySelector('[data-id="messageBox"]').value;
        this.buttonDisabled = (this.inputMessage) ? false : true;
    }

    //calling the LWC controller to perform the call to Twilio REST API Service on "Send" button click
    handleClick(){
        sendGoldSMS({ AccountName: this.name, customMessage : this.inputMessage })
            .then((result) => {
                console.log('success');
                console.log(result);
                this.showToastSuccessMessage();
                this.resetComponent();
            })
            .catch((error) => {
                console.log('error');
                console.log(error);
                this.showToastErrorMessage();
                this.resetComponent();
            });
    }

    //reset initial LWC configuration
    resetComponent(){
        this.buttonDisabled = true;
        this.inputMessage = null;
        this.template.querySelector('[data-id="messageBox"]').value = null;
    }

    //displaying a successful show toast message when no errors
    showToastSuccessMessage(){
        const event = new ShowToastEvent({
            title: 'Success!',
            message: 'Your SMS message has been sent',
            variant : 'success'
        });
        this.dispatchEvent(event);
    }

    //displaying an error show toast message when errors
    showToastErrorMessage(){
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'We had some issues sending your SMS message, please contact the assistance',
            variant : 'error'
        });
        this.dispatchEvent(event);
    }
}