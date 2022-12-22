public class twilioRestCall {
    //Custom Labels defined variables
    private static final String ACCOUNT_SID = System.Label.ACCOUNT_SID; //Twilio Account name used to authenticate API requests
    private static final String AUTH_TOKEN = System.Label.AUTH_TOKEN; //Twilio authentication token for the Twilio account. It is used in combination with the account SID to authenticate API requests
    private static final String CEOPhoneNumber = System.Label.CEO_Business_Number; 
    private static final String smsMessageLabel = System.Label.GOLD_SMS_Body_Text; 
    private static final String TwilioNumber = System.Label.TWILIO_NUMBER;

    //Twilio URL Endpoint
    private static final String TWILIO_URL = 'https://api.twilio.com/2010-04-01/Accounts/' + ACCOUNT_SID + '/Messages.json';
 

    //invocable method from LWC using a custom message
    @AuraEnabled
    public static void sendGoldNotifyMessageLWC(String AccountId,String AccountName,String AccountNumber,String customMessage){
        sendGoldNotifyMessage(AccountId,AccountName,customMessage,AccountNumber,TwilioNumber);

    }

    //invocable from account trigger with empty "customMessage"
    public static void sendGoldNotifyMessageTrigger(String AccountId,String AccountName,String customMessage){
        sendGoldNotifyMessage(AccountId,AccountName,customMessage,CEOPhoneNumber,TwilioNumber);

    }

    //future method to perfom the callout to "Twilio REST API Service" sending out the SMS using the "CEOPhoneNumber" as recipient, "AccountName" to be used within the text message,
    //"TwilioNumber" the phone number which the SMS will be sent from,"customMessage" used whenever called from Account page "LWC" to send a custom message ("null" when called from "Send SMS GOLD - Flow"  to use standard SMS message)
    @Future(callout=true)
    public static void sendGoldNotifyMessage(String AccountId,String AccountName,String customMessage,String recipientNumber,String TwilioNumber) {
        try{

            Account Account = new Account(Id = AccountId,Name = AccountName);
            
            //Object useful to track the response from the "Twilio REST API Service"
            Log__c responseLog = new Log__c(Class_Name__c = 'twilioRestCall',Method_Name__c = 'sendGoldNotifyMessage');
            String messageBody = '';

            //identify whenever the SMS message has to be the standard one (defined in Custom Labels) or custom one inserted by internal users
            if(customMessage == null) {
                smsMessage messageBodyObject = (smsMessage) JSON.deserialize(smsMessageLabel,smsMessage.class);
                messageBody = messageBodyObject.firstPart + Account.Name + messageBodyObject.secondPart;
            }

            else{
                messageBody = customMessage;
            }

            //calling "Twilio REST API Service"
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(TWILIO_URL);
            request.setMethod('POST');
            Blob headerValue = Blob.valueOf(ACCOUNT_SID + ':' + AUTH_TOKEN);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            request.setBody('To='+EncodingUtil.urlEncode(recipientNumber,'UTF-8')+'&From='+EncodingUtil.urlEncode(TwilioNumber,'UTF-8')+'&Body='+messageBody);
        
            HttpResponse response = http.send(request);

            //logging the response details 
            responseLog.Status__c = response.getStatus();
            responseLog.Status_Code__c = '' + response.getStatusCode();
            responseLog.Message__c = response.getBody();

            insert responseLog;

            if(response.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus() + ' , response body :' + response.getBody());
            } else {
                System.debug(response.getBody());

                //update the account boolean field to "true" whenever the Twilio REST API Service answer correctly
                Account.sms_GOLD_Sent__c = true;

                update Account;
            }

        } catch (Exception ex) {
            // Log the error message and stack trace
            System.debug(ex.getMessage() + ': ' + ex.getStackTraceString());
            System.debug('An error occurred while calling Twilio API REST Service');

            //creating a log record with error information whenever something goes wrong within the callout because of the future method running async
            Log__c errorLog = new Log__c(Class_Name__c = 'twilioRestCall',Method_Name__c = 'sendGoldNotifyMessage',Message__c = ex.getMessage() + ': ' + ex.getStackTraceString(),Status__c = 'Error');
            insert errorLog;
        }

    }   
    
    //useful to spilit the SMS mesage in two parts through "Custom Labels" and make it more easily editable and avoiding hard coded text
    public class smsMessage {
        public String firstPart;
        public String secondPart;
    }

}