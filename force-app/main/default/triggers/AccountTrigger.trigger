trigger AccountTrigger on Account (after update) {

    if (Trigger.isUpdate) {
        if (Trigger.isAfter) {
            for(Account acc : Trigger.new) {
                if(acc.Customer_classification__c == 'GOLD' && acc.sms_GOLD_Sent__c == false){
                    AccountTriggerHandler.sendGOLDMessage(acc.Name);
                }
            }
        }
    }

}