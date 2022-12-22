@isTest(SeeAllData = false)
public with sharing class twilioAccountPageController_Test {

    //setup the test data 
    @testSetup static void setup() {
        Account acc = new Account(Name = 'Test Account',Total_Customer_Spend__c = 0);
        insert acc;
        
    }


    //testing the call of Twilio REST API Service
    @isTest
    public static void testSendGoldNotifyMessageLWC(){
        Test.startTest();

        List<Account> acc = [SELECT Id,Name,Customer_classification__c,Total_Customer_Spend__c FROM Account WHERE Name = 'Test Account'];

        Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock());
        twilioAccountPageController.sendGoldNotifyMessageLWC(acc[0].Name,'custom Message');
        Test.stopTest();
    }

}