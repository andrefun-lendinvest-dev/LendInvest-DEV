public with sharing class twilioAccountPageController {
   
    //calling the Twilio API REST Service
    @AuraEnabled
    public static void sendGoldNotifyMessageLWC(String AccountName,String customMessage){
        twilioRestCall.sendGoldNotifyMessageTrigger(AccountName,customMessage);
    }
}
