public with sharing class ApiContactsClass {
    public ApiContactsClass() {}
    
    class TestContact {
        public List<ContactInfo> contacts {get; set;}
    }
    
    class ContactInfo {
        public String id;
        public String name; 
        public String email; 
        public String address;
        public String gender;
        // public PhoneInfo phone;
    }

    class PhoneInfo {
        public String mobile;
        public String home;
        public String office;
    }

    @AuraEnabled
    public static List<ApiContacts__c> insertData() {    
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.androidhive.info/contacts/');
        req.setMethod('GET');               
        
        try {            
            Http http = new Http();
            HTTPResponse res = http.send(req);            
            ApiContactsClass.TestContact testContacts = (ApiContactsClass.TestContact)JSON.deserialize(res.getBody(), ApiContactsClass.TestContact.class);
            
            List<ApiContacts__c> ac = new List<ApiContacts__c>();

            for(integer i = 0; i< 12; i++) {
                
                ApiContacts__c acc = new ApiContacts__c();

                acc.id__c = testContacts.contacts[i].id;
                acc.name__c = testContacts.contacts[i].name;
                acc.email__c = testContacts.contacts[i].email;
                acc.address__c = testContacts.contacts[i].address;
                acc.gender__c = testContacts.contacts[i].gender;
                
                ac.add(acc);
               
            }
             insert ac;
            
             return ac;
            
        } catch (System.Exception e) {          
            // this.id = e.getMessage();    
            return null;
        }            
    }
    
      @AuraEnabled
      public static List<ApiContacts__c> deleteData() {
        List<ApiContacts__c> ac = [SELECT id__c, name__c, email__c, address__c, gender__c FROM ApiContacts__c];
        delete ac;
        return ac;
    }
}