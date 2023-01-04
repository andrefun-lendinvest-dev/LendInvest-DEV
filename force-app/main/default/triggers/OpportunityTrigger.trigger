trigger OpportunityTrigger on Opportunity (before update,before insert,before delete) {
    Map<String,OpportunityTriggerHandler.AccountToUpdate> AccToUpdateMap = new Map<String,OpportunityTriggerHandler.AccountToUpdate>();

    if(Trigger.isInsert){
        if(Trigger.isBefore){
            for(Opportunity opp : Trigger.new){
                if(opp.StageName == System.Label.Opportunity_Stage_Closed_Won){
                    OpportunityTriggerHandler.addAccountTotalCustomerSpend(opp,AccToUpdateMap);
                }
            }
        }
    }

    if (Trigger.isUpdate) {
        if (Trigger.isBefore) {

            for(Opportunity opp : Trigger.new) {

                Opportunity oldOpp = trigger.oldMap.get(opp.Id);
                Opportunity newOpp = trigger.newMap.get(opp.Id);

                //checking if the opportunity has changed account and replacing figures within old and new account consequently
                if(oldOpp.AccountId != newOpp.AccountId){
                    if(newOpp.StageName == System.Label.Opportunity_Stage_Closed_Won && oldOpp.StageName != System.Label.Opportunity_Stage_Closed_Won ){
                        OpportunityTriggerHandler.addAccountTotalCustomerSpend(newOpp,AccToUpdateMap);
                    } 
                    
                    else if (newOpp.StageName != System.Label.Opportunity_Stage_Closed_Won && oldOpp.StageName == System.Label.Opportunity_Stage_Closed_Won ){
                        OpportunityTriggerHandler.removeAccountTotalCustomerSpend(oldOpp,AccToUpdateMap);
                    }
                    
                    else if(newOpp.StageName == System.Label.Opportunity_Stage_Closed_Won && oldOpp.StageName == System.Label.Opportunity_Stage_Closed_Won ){
                        OpportunityTriggerHandler.addAccountTotalCustomerSpend(newOpp,AccToUpdateMap);
                        OpportunityTriggerHandler.removeAccountTotalCustomerSpend(oldOpp,AccToUpdateMap);
                    }
                    
                } else {
                                    
                    //checking if the opportunity keeps stage "Closed Won" but change the amount to change it on the relative account record as well
                    if(oldOpp.StageName == System.Label.Opportunity_Stage_Closed_Won && newOpp.StageName == System.Label.Opportunity_Stage_Closed_Won 
                       && oldOpp.Amount != newOpp.Amount){
                        OpportunityTriggerHandler.modifyAccountTotalCustomerSpend(newOpp,AccToUpdateMap,true);
                        OpportunityTriggerHandler.modifyAccountTotalCustomerSpend(oldOpp,AccToUpdateMap,false);
                     }
    
                    //checking if the new opportunity is moving from a stage different from "Closed won" to "Closed won" to add the new amount to the total
                    if(oldOpp.StageName != System.Label.Opportunity_Stage_Closed_Won && newOpp.StageName == System.Label.Opportunity_Stage_Closed_Won){
                        OpportunityTriggerHandler.addAccountTotalCustomerSpend(opp,AccToUpdateMap);
                    }
    
                    //checking if the new opportunity is moving from a stage of "Closed won" to a non-"Closed won" stage to remove the relative amount from the total
                    if(oldOpp.StageName == System.Label.Opportunity_Stage_Closed_Won && newOpp.StageName != System.Label.Opportunity_Stage_Closed_Won ){
                        OpportunityTriggerHandler.removeAccountTotalCustomerSpend(opp,AccToUpdateMap);
                    }

                }



            }

        }
    }


    if(trigger.isDelete){
        if(trigger.isBefore){
        
            //checking if a "Stage Closed Won" opportunity is being delete and in case remove the relative amount from corresponding "Account Total Customer Spend" figure
            for(Opportunity opp : trigger.old){
                if(opp.StageName == System.Label.Opportunity_Stage_Closed_Won){
                    OpportunityTriggerHandler.removeAccountTotalCustomerSpend(opp,AccToUpdateMap);  
                }

            }

        }
    }

    //finally calling the method to update all accounts processed during the trigger run and added within the map "AccToUpdateMap"
    if(AccToUpdateMap.isEmpty() == false){
        OpportunityTriggerHandler.updateAccountMap(AccToUpdateMap);
    }
}
