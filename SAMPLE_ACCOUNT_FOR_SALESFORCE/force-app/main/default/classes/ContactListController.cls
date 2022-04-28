public class ContactListController {
    @AuraEnabled
    public static Contact createContact (Contact con, Id AccountId){
        con.AccountId = AccountId;
        insert con;
        system.debug('The inserted Id is' + con.Id);
        return con;
    }
}