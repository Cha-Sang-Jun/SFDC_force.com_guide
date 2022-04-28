public with sharing class ApiContacts {
    
     public String id {get; set;}
     public String name {get; set;}
     public String email {get; set;}
     public String address {get; set;}
     public String gender {get; set;}
     public String phone {get; set;}
    
    // public List<ContactInfo> contactsList {get; set;}
    
    // public List<PhoneInfo> phoneList {get; set;}
    
    public List<ApiContacts__c> contactsList {get; set;}
   
    public ApiContacts() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.androidhive.info/contacts/');
        req.setMethod('GET');               
        
        try {            
            Http http = new Http();
            HTTPResponse res = http.send(req);            
            ApiContacts.TestContact testContacts = (ApiContacts.TestContact)JSON.deserialize(res.getBody(), ApiContacts.TestContact.class);
            
            // contactsList = new List<ContactInfo>();
             
            ApiContacts__c ac = new ApiContacts__c();
            
            contactsList = new List<ApiContacts__c>();
            
            // phoneList = new List<PhoneInfo>();            
            
            for(integer i = 0; i<8; i++) {
                ContactInfo contactInfo = new ContactInfo();
                
                // PhoneInfo phoneInfo = new PhoneInfo();
                
                ac.id__c = testContacts.contacts[i].id;
                ac.name__c = testContacts.contacts[i].name;
                ac.email__c = testContacts.contacts[i].email;
                ac.address__c = testContacts.contacts[i].address;
                ac.gender__c = testContacts.contacts[i].gender;  
                // contactInfo.phoneInfo.mobile = testContacts.contacts[i].phone;
                
                // contactsList.add(contactInfo);
                contactsList.add(ac);
                
            }   
            
         	// insert ac;
            
        } catch (System.Exception e) {          
           	this.id = e.getMessage();          
        }    
    }
    
    class TestContact {
        public List<ApiContacts> contacts  {get; set;}
    }
    
    class ContactInfo {
        public String id {get; set;}
        public String name {get; set;}
        public String email {get; set;}
        public String address {get; set;}
        public String gender {get; set;}
        // public PhoneInfo phone {get; set;}
    }
    
 /*    class PhoneInfo {
        public String id;
        public String name;
        public String email;
        public String address;
        public String gender;
    
        public String mobile {get; set;}
        public String home {get; set;}
        public String office {get; set;}
    } */
 
}