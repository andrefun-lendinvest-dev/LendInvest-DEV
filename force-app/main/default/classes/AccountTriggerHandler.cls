public with sharing class AccountTriggerHandler {
    
    public static void sendGOLDMessage(String AccountName){
        twilioRestCall.sendGoldNotifyMessage(AccountName);
    }

}

