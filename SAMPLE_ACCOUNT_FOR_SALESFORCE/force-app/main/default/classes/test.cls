public class test {
    
    @AuraEnabled
    public static List<Account> initComponent(){
        System.debug(' >>> initComponent >> ');
        return [SELECT Id, Name, AccountNumber FROM Account ORDER BY CreatedDate DESC];
    }
    
    @AuraEnabled
    public static List<Account> findAll(){
        System.debug(' >>> initComponent >> ');
        return [SELECT Id, Name, AccountNumber FROM Account ORDER BY CreatedDate DESC];
    }
}