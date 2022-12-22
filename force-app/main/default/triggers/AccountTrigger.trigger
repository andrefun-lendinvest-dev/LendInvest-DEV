trigger AccountTrigger on Account (before update) {

    if (Trigger.isUpdate) {
        if (Trigger.isBefore) {
            for(Account acc : Trigger.new) {
                //calling the trigger handler to set the "Customer classification" to "GOLD" after reaching £50000 on "Total_Customer_Spend__c"
                if(acc.Total_Customer_Spend__c >= 50000 && acc.Customer_classification__c != System.Label.GOLD_Value){
                    AccountTriggerHandler.setGoldClassification(acc);
                }

                //calling the trigger handler to set the "Customer classification" to "SILVER" after reaching £25000 on "Total_Customer_Spend__c"
                else if(acc.Total_Customer_Spend__c < 50000 && acc.Total_Customer_Spend__c >= 25000 && acc.Customer_classification__c != System.Label.SILVER_Value){
                    acc.Customer_classification__c = System.Label.SILVER_Value;
                }

                //calling the trigger handler to set the "Customer classification" to "BRONZE" after reaching £10000 on "Total_Customer_Spend__c"
                else if(acc.Total_Customer_Spend__c < 25000 && acc.Total_Customer_Spend__c >= 10000 && acc.Customer_classification__c != System.Label.BRONZE_Value){
                    acc.Customer_classification__c = System.Label.BRONZE_Value;
                }

                //calling the trigger handler to set the "Customer classification" to "NULL" after reaching any value < £10000 on "Total_Customer_Spend__c"
                else if(acc.Total_Customer_Spend__c < 10000 && acc.Customer_classification__c != null){
                    acc.Customer_classification__c = null;
                }
            }
        }
    }

}