public with sharing class CntrlBookList {
    public CntrlBookList() {}
    
    @AuraEnabled(cacheable=true)
    public static List<Book__c> getBookList(){
        System.debug('List First Call !!!');
        try {
            return [SELECT Id, Name, BookNo__c, BookType__c FROM Book__c ORDER BY BookNo__c];
            
        } catch (Exception e) {
        System.debug('List Second Call !!!');
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled 
    public static Book__c insertBook(Book__c book) {
      System.debug('Insert First Call !!!');
     insert book;
     return book;
    }

    // @AuraEnabled
    // public static List<Book__c> deleteBook(String BookId) {
    //     List<Book__c> book=[Select Id from Book__c where id=:BookId];
    //     delete book;
    //     return book;
    // }
        
    // @AuraEnabled(cacheable=true)
    // public static Book__c selectById(String BookId) {
    //     try {
    //         Book__c book = (Book__c)Database.query('SELECT Id, Name, BookNo__c, BookType__c FROM Book__c WHERE id=:BookId' );
    //         return book;
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }

    // @AuraEnabled(cacheable=true)
    // public static Book__c selectById(String BookId) {
    //     System.debug('SelectById First Call !!!');
    //     return [SELECT Id, Name, BookNo__c, BookType__c FROM Book__c WHERE id=:BookId];
    // }

    /**
     * lwc.ver selectById
     */
    @AuraEnabled(cacheable=true)
    public static Book__c selectById(String recordId) {
        System.debug('SelectById First Call !!!');
        Book__c book = [SELECT Id, Name, BookNo__c, BookType__c FROM Book__c WHERE id=:recordId];
        System.debug(book);
        return book;
    }

    @AuraEnabled
    public static Book__c updateBook(Book__c book){
        try {
            // update book;
            upsert book;
            return book;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * lwc.ver deleteBook
     */
    @AuraEnabled
    public static void deleteBook(Book__c book){
        try {
            delete book;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


}