public with sharing class AccountTriggerHandler {
    
    //updating the "Customer classification" field on the account with the correct value
    public static void setGoldClassification(Account acc){
        try{
            String CEONumber = System.Label.CEO_Business_Number;
            acc.Customer_classification__c = System.Label.GOLD_Value;

            if(acc.sms_GOLD_Sent__c == false){
                twilioRestCall.sendGoldNotifyMessage(acc.Id,acc.Name,null,CEONumber,true);
            }   
        }
        catch(Exception ex){
            System.debug(ex.getMessage() + ': ' + ex.getStackTraceString());
            System.debug('An error occurred while updating the account or calling Twilio API Service');
        }

    }

}