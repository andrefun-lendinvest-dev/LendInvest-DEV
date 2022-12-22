public with sharing class AccountTriggerHandler {
    
    //updating the "Customer classification" field on the account and, if the "sms_GOLD_Sent__c" is set to false, calling Twilio REST API Service to send out the SMS 
    //for the first time relative to this account. After setting the boolean to true to avoid sending multiple gold status SMSs in future
    public static void setGoldClassification(Account acc){
        try{
            acc.Customer_classification__c = System.Label.GOLD_Value;

            if(acc.sms_GOLD_Sent__c == false){
                twilioRestCall.sendGoldNotifyMessageTrigger(acc.Name,null);
                acc.sms_GOLD_Sent__c = true;
            }   
        }
        catch(Exception ex){
            System.debug(ex.getMessage() + ': ' + ex.getStackTraceString());
            System.debug('An error occurred while updating the account or calling Twilio API Service');
        }

    }

}

