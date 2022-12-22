@isTest(SeeAllData=false)
private class twilioRestCall_Test {
    private static final String TEST_ACCOUNT_NAME = 'Test Account';
    private static final String TEST_CEO_NUMBER = '+447832249674';
    private static final String TEST_TWILIO_NUMBER = '+1223434324';
    private static final String CUSTOM_MESSAGE = 'Test message';

    //method to test the REST Callot used to send the SMS through Twilio API Service
    @IsTest
    static void testFutureCall() {
      Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock());
      Test.startTest();
      twilioRestCall.sendGoldNotifyMessage(TEST_ACCOUNT_NAME,null,TEST_CEO_NUMBER, TEST_TWILIO_NUMBER);
      Test.stopTest();

      List<Log__c> Logs = [SELECT Id,Status__c,Status_Code__c,Message__c FROM Log__c];
      System.assertEquals(1, Logs.size());
      System.assertEquals('201', Logs[0].Status_Code__c);
    }

    //method to test the trigger method call
    @IsTest
    static void testTriggerCall() {
      Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock());
      Test.startTest();
      twilioRestCall.sendGoldNotifyMessageTrigger(TEST_ACCOUNT_NAME,CUSTOM_MESSAGE);
      Test.stopTest();

      List<Log__c> Logs = [SELECT Id,Status__c,Status_Code__c,Message__c FROM Log__c];
      System.assertEquals(1, Logs.size());
      System.assertEquals('201', Logs[0].Status_Code__c);

    }

    //method to test exceptions
    @IsTest
    static void testExceptions() {
      Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock());
      Test.startTest();
      twilioRestCall.sendGoldNotifyMessage(TEST_ACCOUNT_NAME,null,null, TEST_TWILIO_NUMBER);
      Test.stopTest();

    }
}
