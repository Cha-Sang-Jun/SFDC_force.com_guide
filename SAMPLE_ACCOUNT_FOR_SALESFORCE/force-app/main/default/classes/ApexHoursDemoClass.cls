public with sharing class ApexHoursDemoClass {
    public ApexHoursDemoClass() {

    }

    @AuraEnabled(cacheable = true)
    public static List<Contact> getContactList(){
        return [Select Id, Name, Email From Contact Limit 20];
    }

    @AuraEnabled(cacheable = true)
    public static List<Account> getAccountDetails(){
        return [Select Id, Name From Account Limit 20];
    }
}