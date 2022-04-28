public with sharing class AuraPractice {
    public AuraPractice() {}


    @AuraEnabled
    public static List<Contact> getContactId(){
        try {
            return [SELECT Id, Name, Email FROM Contact];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}