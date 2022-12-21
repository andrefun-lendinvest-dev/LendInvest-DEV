@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"body": "Sent from your Twilio trial account - Great news! A customer has hit GOLD. Test Account 1 Will get VIP treatment.", "num_segments": "1", "direction": "outbound-api", "from": "+12058135430", "date_updated": "Tue, 20 Dec 2022 14:36:10 +0000", "price": null, "error_message": null, "uri": "/2010-04-01/Accounts/ACf72f6f25e43e90029b0781a92d9432c5/Messages/SMb56cde06fda4ddb4a0b7e97af7f5bb89.json", "account_sid": "ACf72f6f25e43e90029b0781a92d9432c5", "num_media": "0", "to": "+447832249674", "date_created": "Tue, 20 Dec 2022 14:36:10 +0000", "status": "queued", "sid": "SMb56cde06fda4ddb4a0b7e97af7f5bb89", "date_sent": null, "messaging_service_sid": null, "error_code": null, "price_unit": "USD", "api_version": "2010-04-01", "subresource_uris": {"media": "/2010-04-01/Accounts/ACf72f6f25e43e90029b0781a92d9432c5/Messages/SMb56cde06fda4ddb4a0b7e97af7f5bb89/Media.json"}}');
        res.setStatusCode(200);
        return res;
    }
}