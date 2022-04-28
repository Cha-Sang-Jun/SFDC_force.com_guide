public with sharing class testController {
    
    public String id {get; set;}
    public String name {get; set;}
    public String email {get; set;}
    public String address {get; set;}
    public String gender {get; set;}
    // public String phone {get; set;}
    
    public List<ContactInfo> contactsList {get; set;}
    
    // public List<PhoneInfo> phoneList {get; set;}
    
    
    /*   public testController() {
HttpRequest req = new HttpRequest();
req.setEndpoint('https://api.androidhive.info/contacts/');
req.setMethod('GET');               

try {            
Http http = new Http();
HTTPResponse res = http.send(req);            
testController.TestContact testContacts = (testController.TestContact)JSON.deserialize(res.getBody(), testController.TestContact.class);

contactsList = new List<ContactInfo>();

// phoneList = new List<PhoneInfo>();

for(integer i = 0; i<3; i++) {
ContactInfo contactInfo = new ContactInfo();

// ApiContacts ac = new ApiContacts();

// PhoneInfo phoneInfo = new PhoneInfo();

contactInfo.id = testContacts.contacts[i].id;
contactInfo.name = testContacts.contacts[i].name;
contactInfo.email = testContacts.contacts[i].email;
contactInfo.address = testContacts.contacts[i].address;
contactInfo.gender = testContacts.contacts[i].gender;
// contactInfo.phoneInfo.mobile = testContacts.contacts[i].phone;

ac.id__c = testContacts.contacts[i].id;
ac.name__c = testContacts.contacts[i].name;
ac.email__c = testContacts.contacts[i].email;
ac.address__c = testContacts.contacts[i].address;
ac.gender__c = testContacts.contacts[i].gender;

// contactsList.add(contactInfo);
}            

} catch (System.Exception e) {          
this.id = e.getMessage();          
}    
} */
    
    class TestContact {
        public List<ContactInfo> contacts  {get; set;}
    }
    
    class ContactInfo {
        public String id {get; set;}
        public String name {get; set;}
        public String email {get; set;}
        public String address {get; set;}
        public String gender {get; set;}
        // public PhoneInfo phone {get; set;}
    }
    
    
    public void insertData() {    
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.androidhive.info/contacts/');
        req.setMethod('GET');               
        
        try {            
            Http http = new Http();
            HTTPResponse res = http.send(req);            
            testController.TestContact testContacts = (testController.TestContact)JSON.deserialize(res.getBody(), testController.TestContact.class);
            
            for(integer i = 0; i< 12; i++) {

                ApiContacts__c ac = new ApiContacts__c();
                
                ac.id__c = testContacts.contacts[i].id;
                ac.name__c = testContacts.contacts[i].name;
                ac.email__c = testContacts.contacts[i].email;
                ac.address__c = testContacts.contacts[i].address;
                ac.gender__c = testContacts.contacts[i].gender;
                
                insert ac;
            }            
            
        } catch (System.Exception e) {          
            this.id = e.getMessage();          
        }            
    }
    
    public void deleteData() {
        List<ApiContacts__c> ac = [SELECT id__c, name__c, email__c, address__c, gender__c FROM ApiContacts__c];
        delete ac;
        
        /*       ApiContacts__c delApi;

for (ApiContacts__c api : ac) {
if(api.id__c.equalsIgnoreCase('c202')) {    
delApi = api;
break;
}
delete delApi;
} 
*/         
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