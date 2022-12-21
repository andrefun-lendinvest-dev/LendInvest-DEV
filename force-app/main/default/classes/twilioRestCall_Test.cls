@isTest
private class twilioRestCall_Test {
    private static final String TEST_ACCOUNT_NAME = 'Test Account';
    private static final String TEST_CEO_NUMBER = '+447832249674';
    private static final String TEST_TWILIO_NUMBER = '+1223434324';

    //method to test the REST Callot used to send the SMS through Twilio API Service
    @IsTest
    private static void testFutureCall() {
      Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock());
      Test.startTest();
      twilioRestCall.sendGoldNotifyMessage(TEST_ACCOUNT_NAME,null,TEST_CEO_NUMBER, TEST_TWILIO_NUMBER);
      Test.stopTest();

    }

    //method to test the invocable method used within the flow "Send SMS GOLD - Flow"
    @IsTest
    private static void testInvocableMethod() {
      twilioRestCall.InvocableInputs InvocableInput = new twilioRestCall.InvocableInputs();
      List<twilioRestCall.InvocableInputs> testInvocableInputsList = new List<twilioRestCall.InvocableInputs>();

      InvocableInput.AccountName = TEST_ACCOUNT_NAME;
      testInvocableInputsList.add(InvocableInput);
      Test.setMock(HttpCalloutMock.class, new TwilioCalloutMock());

      Test.startTest();
      twilioRestCall.sendGoldNotifyMessageInvocable(testInvocableInputsList);
      Test.stopTest();

    }
}
