public with sharing class CntrlApiContactsDetail {

    public ApiContacts__c apiContacts {get; set;}

    public CntrlApiContactsDetail() {

        apiContacts = getApiContacts();

        if(apiContacts == null) {
            return;
        }
    }
}
