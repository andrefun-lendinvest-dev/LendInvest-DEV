public with sharing class twilioAccountPageController {
   
    //calling the Twilio API REST Service
    @AuraEnabled
    public static void sendGoldNotifyMessageLWC(String AccountId,String AccountName,String AccountNumber,String customMessage){
        twilioRestCall.sendGoldNotifyMessageLWC(AccountId,AccountName,AccountNumber,customMessage);
    }
}
