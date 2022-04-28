global with sharing class TestApiClass {

    public String id {get; set;}
    public String name {get; set;}
    public String email {get; set;}
    public String address {get; set;}
    public String gender {get; set;}
    public String phone {get; set;}

    public TestApiClass() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.androidhive.info/contacts/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        String body = response.getBody();
        // System.debug(body);

        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.geBody());

            id = String.valueOf(result.get('id'));
            name = String.valueOf(result.get('name'));
            email = String.valueOf(result.get('email'));
            address = String.valueOf(result.get('address'));
            gender = String.valueOf(result.get('gender'));
            phone = String.valueOf(result.get('phone'));

        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Serverity.Error, '오류!!');
            ApexPages.addMessage(myMsg);
        }
    }
}
