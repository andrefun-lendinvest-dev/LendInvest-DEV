public with sharing class twilioAccountPageController {
   
    //calling the Twilio API REST Service
    @AuraEnabled
    public static void sendGoldNotifyMessageLWC(Account Account,String customMessage){
        twilioRestCall.sendGoldNotifyMessageTrigger(Account,customMessage);
    }
}
