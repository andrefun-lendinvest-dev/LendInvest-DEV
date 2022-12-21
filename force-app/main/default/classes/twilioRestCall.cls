public class twilioRestCall {
    //Custom Labels defined variables
    private static final String ACCOUNT_SID = System.Label.ACCOUNT_SID; //Twilio Account name used to authenticate API requests
    private static final String AUTH_TOKEN = System.Label.AUTH_TOKEN; //Twilio authentication token for the Twilio account. It is used in combination with the account SID to authenticate API requests
    private static final String CEOPhoneNumber = System.Label.CEO_Business_Number; 
    private static final String smsMessageLabel = System.Label.GOLD_SMS_Body_Text; 
    private static final String TwilioNumber = System.Label.TWILIO_NUMBER;

    //Twilio URL Endpoint
    private static final String TWILIO_URL = 'https://api.twilio.com/2010-04-01/Accounts/' + ACCOUNT_SID + '/Messages.json';


    //invocable method to be use within the "Send SMS GOLD - Flow" with invocable input to add the account name directly from the flow record
    @InvocableMethod(label = 'Send SMS GOLD Method')
    public static void sendGoldNotifyMessageInvocable(List<InvocableInputs> invocableInputsVar){
        sendGoldNotifyMessage(invocableInputsVar[0].AccountName,null,CEOPhoneNumber,TwilioNumber);
    }

    //future method to perfom the callout to "Twilio REST API Service" sending out the SMS using the "CEOPhoneNumber" as recipient, "AccountName" to be used within the text message,
    //"TwilioNumber" the phone number which the SMS will be sent from,"customMessage" used whenever called from Account page "LWC" to send a custom message ("null" when called from "Send SMS GOLD - Flow"  to use standard SMS message)
    @Future(callout=true)
    public static void sendGoldNotifyMessage(String AccountName,String customMessage,String CEOPhoneNumber,String TwilioNumber) {

        //Object useful to track the response from the "Twilio REST API Service"
        Log__c responseLog = new Log__c(Class_Name__c = 'twilioRestCall',Method_Name__c = 'sendGoldNotifyMessage');
        String messageBody = '';

        //identify whenever the SMS message has to be the standard one (defined in Custom Labels) or custom one inserted by internal users
        if(customMessage == null) {
            smsMessage messageBodyObject = (smsMessage) JSON.deserialize(smsMessageLabel,smsMessage.class);
            messageBody = messageBodyObject.firstPart + AccountName + messageBodyObject.secondPart;
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
        request.setBody('To='+EncodingUtil.urlEncode(CEOPhoneNumber,'UTF-8')+'&From='+EncodingUtil.urlEncode(TwilioNumber,'UTF-8')+'&Body='+messageBody);
	
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

        }

    }   
    
    //useful to spilit the SMS mesage in two parts through "Custom Labels" and make it more easily editable and avoiding hard coded text
    public class smsMessage {
        public String firstPart;
        public String secondPart;
    }

    //variable to be set within the Flow "Send SMS GOLD - Flow"
    public class InvocableInputs{

        @InvocableVariable
        public String AccountName;

    }
}