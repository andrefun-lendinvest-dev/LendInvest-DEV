@isTest(SeeAllData = false)
public with sharing class AccountTrigger_Test {

    //setup the test data 
    @testSetup static void setup() {
    
        Account acc = new Account(Name = 'Test Account',Total_Customer_Spend__c = 0);
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test Opp', AccountId = acc.Id,Amount = 25000, StageName = 'Prospecting',CloseDate = Date.Today() + 1);
        insert opp;

    }
    
    //testing when the account switch for the first time to GOLD status
    @isTest
    public static void testSetGoldStatus(){
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock());

        List<Account> acc = [SELECT Id,Name,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account'];
        List<Opportunity> oppList = [SELECT Id,Amount,AccountId,StageName FROM Opportunity WHERE Name = 'Test Opp'];

        oppList[0].Amount = 53000;
        oppList[0].StageName = 'Closed Won';

        update oppList;
       
        Test.stopTest();

        List<Account> acc1 = [SELECT Id,Name,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account'];

        System.assertEquals('Test Account', acc1[0].Name);
        System.assertEquals(53000, acc1[0].Total_Customer_Spend__c);
        System.assertEquals('GOLD', acc1[0].Customer_classification__c);
    }

    //testing exception case
    @isTest
    public static void testSetGoldStatusExpection(){
        Test.startTest();
        AccountTriggerHandler.setGoldClassification(null);
        Test.stopTest();

        List<Account> acc = [SELECT Id,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account'];

        System.assertEquals(0, acc[0].Total_Customer_Spend__c);
        System.assertEquals(null, acc[0].Customer_classification__c);
    }
}
