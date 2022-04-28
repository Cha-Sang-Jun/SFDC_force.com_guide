public class custom_controller {

    private String sortOrder = 'LastName';
    
    public List<Contact> getContact() {
        System.debug('>>> this.sortOrder >>>' + this.sortOrder);
        System.debug('>>> getContacts >>>');
        
        List<Contact> results = Database.query(
        	' SELECT Id, Name, FirstName, LastName, Title, Email' +
            ' FROM Contact' +
            ' ORDER BY ' + sortOrder + ' DESC' +
            ' LIMIT 10'
        );
        return results;
    }
}