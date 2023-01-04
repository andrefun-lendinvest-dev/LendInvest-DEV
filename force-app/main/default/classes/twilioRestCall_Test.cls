@isTest(SeeAllData=false)
private class twilioRestCall_Test {
    private static final String TEST_CEO_NUMBER = '+447832249674';
    private static final String TEST_TWILIO_NUMBER = '+1223434324';
    private static final String CUSTOM_MESSAGE = 'Test message';

    //setup the test data 
    @testSetup static void setup() {
      Account acc = new Account(Name = 'Test Account',sms_GOLD_Sent__c = false);
      insert acc;
  }

    //method to test the REST Callot used to send the SMS through Twilio API Service
    @IsTest
    static void testFutureCall() {
      List<Account> acc = [SELECT Id,Name,sms_GOLD_Sent__c FROM Account WHERE Name = 'Test Account'];

      Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock());
      Test.startTest();
      twilioRestCall.sendGoldNotifyMessage(acc[0].Id,acc[0].Name,null,TEST_CEO_NUMBER,true);
      Test.stopTest();

      List<Log__c> Logs = [SELECT Id,Account__c,Status__c,Status_Code__c,Message__c FROM Log__c];

      System.assertEquals(1, Logs.size());
      System.assertEquals(acc[0].Id, Logs[0].Account__c); 
      System.assertEquals('201', Logs[0].Status_Code__c);
    }

    //method to test the trigger method call
    @IsTest
    static void testTriggerCall() {
      List<Account> acc = [SELECT Id,Name,sms_GOLD_Sent__c FROM Account WHERE Name = 'Test Account'];
      Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock());
      Test.startTest();
      twilioRestCall.sendGoldNotifyMessage(acc[0].Id,acc[0].Name,CUSTOM_MESSAGE,TEST_CEO_NUMBER,true);
      Test.stopTest();

      List<Log__c> Logs = [SELECT Id,Account__c,Status__c,Status_Code__c,Message__c FROM Log__c];
      System.assertEquals(1, Logs.size());
      System.assertEquals(acc[0].Id, Logs[0].Account__c);
      System.assertEquals('201', Logs[0].Status_Code__c);

    }

    //method to test exceptions
    @IsTest
    static void testExceptions() {
      List<Account> acc = [SELECT Id,Name,sms_GOLD_Sent__c FROM Account WHERE Name = 'Test Account'];

      Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock());
      Test.startTest();
      twilioRestCall.sendGoldNotifyMessage(acc[0].Id,acc[0].Name,null,null,true);
      Test.stopTest();

      List<Log__c> Logs = [SELECT Id,Account__c,Status__c,Status_Code__c,Message__c FROM Log__c];
      System.assertEquals(1, Logs.size());
      System.assertEquals(acc[0].Id, Logs[0].Account__c);
      System.assertEquals('Error', Logs[0].Status__c);
    }
}
