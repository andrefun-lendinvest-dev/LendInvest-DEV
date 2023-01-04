public with sharing class OpportunityTriggerHandler {

    //main method to do the calculation whenever the amount needs to be added or removed from the total
    public static void modifyAccountTotalCustomerSpend(Opportunity newOpp,Map<String,AccountToUpdate> AccToUpdateMap, boolean addAmount){
        try {
            AccountToUpdate accountToUpdate;
            if (!AccToUpdateMap.containsKey(newOpp.AccountId)){
                accountToUpdate = new AccountToUpdate();
                accountToUpdate.AccountId = newOpp.AccountId;
                AccToUpdateMap.put(accountToUpdate.AccountId,accountToUpdate);
            }
            else{
                accountToUpdate = AccToUpdateMap.get(newOpp.AccountId);
            }
            if (addAmount){
                accountToUpdate.TotalToAdd += newOpp.Amount;
            }
            else {
                accountToUpdate.TotalToRemove += newOpp.Amount;
            }
        }
        catch (Exception ex) {
            // Log the error message and stack trace
            System.debug(ex.getMessage() + ': ' + ex.getStackTraceString());
            System.debug('An error occurred while modifying the account total customer spend');
        }

    }
    
    public static void addAccountTotalCustomerSpend(Opportunity newOpp, Map<String,AccountToUpdate> AccToUpdateMap){
            modifyAccountTotalCustomerSpend(newOpp, AccToUpdateMap, true);
    }
    
    public static void removeAccountTotalCustomerSpend(Opportunity newOpp, Map<String,AccountToUpdate> AccToUpdateMap){
            modifyAccountTotalCustomerSpend(newOpp, AccToUpdateMap, false);
    }
    
    public static void updateAccountMap(Map<String,AccountToUpdate> AccToUpdateMap){
        try{
            List<Account> AccList = [SELECT Id,Total_Customer_Spend__c,Customer_classification__c FROM Account WHERE Id IN: AccToUpdateMap.keySet()];
    
            for(Account singleAcc : AccList){
                Decimal updatedTotalCustomerSpend = AccToUpdateMap.get(singleAcc.Id).TotalToAdd - AccToUpdateMap.get(singleAcc.Id).TotalToRemove ;
                singleAcc.Total_Customer_Spend__c += updatedTotalCustomerSpend;
            }
        
            update AccList;
        }
        catch (Exception ex) {
            System.debug(ex.getMessage() + ': ' + ex.getStackTraceString());
            System.debug('An error occurred while updating the account');
        }
        
    }
    
    public class AccountToUpdate{
    
        public String AccountId;
        public Decimal TotalToAdd = 0;
        public Decimal TotalToRemove = 0;
    }
    
}
