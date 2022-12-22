@isTest(SeeAllData = false) 
public with sharing class OpportunityTrigger_Test {

    //setup the test data 
    @testSetup static void setup() {
        
        Account acc = new Account(Name = 'Test Account',Total_Customer_Spend__c = 0);
        insert acc;

        Account acc1 = new Account(Name = 'Test Account1',Total_Customer_Spend__c = 0);
        insert acc1;
        
        Opportunity opp = new Opportunity(Name='Test Opp', AccountId = acc.Id,Amount = 25000, StageName = 'Prospecting',CloseDate = Date.Today() + 1);
        insert opp;

        Opportunity opp1 = new Opportunity(Name='Test Opp1', AccountId = acc1.Id,Amount = 26000, StageName = 'Closed Won',CloseDate = Date.Today() + 1);
        insert opp1;
    }

    //testing moving the opportunity stage to "Closed Won" from a different previous stage
    @isTest
    static void testMoveToClosedWon() {

        Test.startTest();

        List<Opportunity> oppList = [SELECT Id,Amount,AccountId,StageName FROM Opportunity WHERE Name = 'Test Opp'];
        oppList[0].Amount = 26000;
        oppList[0].StageName = 'Closed Won';
        update oppList;

        Test.stopTest();

        List<Account> acc = [SELECT Id,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account'];

        System.assertEquals(26000, acc[0].Total_Customer_Spend__c);
        System.assertEquals('SILVER', acc[0].Customer_classification__c);

    }


    //testing moving away from "Closed Won" stage to a different one
    @isTest
    static void testMoveoutFromClosedWon() {

        Test.startTest();

        List<Opportunity> oppList = [SELECT Id,Amount,AccountId,StageName FROM Opportunity WHERE Name = 'Test Opp1'];
        oppList[0].Amount = 26000;
        oppList[0].StageName = 'Prospecting';
        update oppList;
        

        Test.stopTest();

        List<Account> acc = [SELECT Id,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account1'];

        System.assertEquals(0, acc[0].Total_Customer_Spend__c);
        System.assertEquals(null, acc[0].Customer_classification__c);

    }


    //testing assigning two opportunities to the same account chaning values within them
    @isTest
    static void updateMultipleOpp() {

        Test.startTest();

        List<Opportunity> oppList = [SELECT Id,Amount,AccountId,StageName FROM Opportunity];
        List<Account> accList = [SELECT Id FROM Account ];

        for(Opportunity opp : oppList){
            opp.Amount = 26000;
            opp.StageName = 'Prospecting';
            opp.AccountId = accList[0].Id;
        }

        update oppList;
        

        Test.stopTest();

        List<Account> acc = [SELECT Id,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account1'];

        System.assertEquals(0, acc[0].Total_Customer_Spend__c);
        System.assertEquals(null, acc[0].Customer_classification__c);

    }


    //testing deleting an opportunity
    @isTest
    static void testDeleteOpp() {

        Test.startTest();

        List<Opportunity> oppList = [SELECT Id,Amount,AccountId,StageName FROM Opportunity WHERE Name = 'Test Opp1'];
        delete oppList;

        Test.stopTest();

        List<Account> acc = [SELECT Id,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account1'];

        System.assertEquals(0, acc[0].Total_Customer_Spend__c);
        System.assertEquals(null, acc[0].Customer_classification__c);

    }


    //testing chaning the amount field of an opportunity and moving the stage to "Closed Won"
    @isTest
    static void testChangingAmount() {

        Test.startTest();

        List<Opportunity> oppList = [SELECT Id,Amount,AccountId,StageName FROM Opportunity WHERE Name = 'Test Opp1'];
        oppList[0].Amount = 12000;
        oppList[0].StageName = 'Closed Won';
        update oppList;

        Test.stopTest();

        List<Account> acc = [SELECT Id,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account1'];

        System.assertEquals(12000, acc[0].Total_Customer_Spend__c);
        System.assertEquals('BRONZE', acc[0].Customer_classification__c);

    }

    //testing switching opportunity account
    @isTest
    static void testSwitchingAccounts() {

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock());

        List<Account> acc = [SELECT Id,Name,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account'];
        List<Opportunity> oppList = [SELECT Id,Amount,AccountId,StageName FROM Opportunity WHERE Name = 'Test Opp'];
        List<Opportunity> oppList1 = [SELECT Id,Amount,AccountId,StageName FROM Opportunity WHERE Name = 'Test Opp1'];

        oppList1[0].AccountId = acc[0].Id;
        oppList[0].StageName = 'Closed Won';

        update oppList;
        update oppList1;
       
        Test.stopTest();

        List<Account> acc1 = [SELECT Id,Name,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account'];

        System.assertEquals('Test Account', acc1[0].Name);
        System.assertEquals(51000, acc1[0].Total_Customer_Spend__c);
        System.assertEquals('GOLD', acc1[0].Customer_classification__c);

    }

    //testing exceptions cases
    @isTest
    static void testExceptions() {
        OpportunityTriggerHandler.AccountToUpdate accToUpdate = new OpportunityTriggerHandler.AccountToUpdate();
        List<Account> acc1 = [SELECT Id,Name,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account'];

        accToUpdate.AccountId = acc1[0].Id;
        accToUpdate.TotalToAdd = null;
        accToUpdate.TotalToRemove = null;

        Test.startTest();
        OpportunityTriggerHandler.modifyAccountTotalCustomerSpend(null,null,null, true);
        OpportunityTriggerHandler.updateAccountMap(new Map<String,OpportunityTriggerHandler.AccountToUpdate>{accToUpdate.AccountId => accToUpdate});
        Test.stopTest();


    }
}
