@isTest(SeeAllData = false)
public with sharing class twilioAccountPageController_Test {

    //setup the test data 
    @testSetup static void setup() {
        Account acc = new Account(Name = 'Test Account',Total_Customer_Spend__c = 0,AccountNumber = '+44732939302');
        insert acc;
        
    }


    //testing the call of Twilio REST API Service
    @isTest
    public static void testSendGoldNotifyMessageLWC(){
        Test.startTest();

        List<Account> acc = [SELECT Id,Name,AccountNumber,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account'];

        Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock()); 
        twilioAccountPageController.sendGoldNotifyMessageLWC(acc[0].Id,acc[0].Name,acc[0].AccountNumber,'custom Message');
        Test.stopTest();

        List<Log__c> Logs = [SELECT Id,Status__c,Account__c,Status_Code__c,Message__c FROM Log__c];
        System.assertEquals(1, Logs.size());
        System.assertEquals(acc[0].Id, Logs[0].Account__c);
        System.assertEquals('201', Logs[0].Status_Code__c);
    }

}
