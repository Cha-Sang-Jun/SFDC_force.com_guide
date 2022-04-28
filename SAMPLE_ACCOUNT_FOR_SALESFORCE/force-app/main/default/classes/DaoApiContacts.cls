public with sharing class DaoApiContacts {


    /**
     * @description ApiContacts 객체의 ID에 해당하는 정보 SELECT
     */
    public static List<ApiContacts__c> fincById(ID apiContactsId) {

        List<ApiContacts__c> apiContactsList = [
            SELECT
                Id,
                Name,
                id__c,
                name__c,
                email__c,
                address__c,
                gender__c
                FROM ApiContacts__c
                WHERE Id = :apiContactsId
        ];

        return apiContactsList;
    }

    /**
     * @description ApiContacts 레코드 삭제
     */
    public static void deleteData(List<ApiContacts__c> apiContactsList) {
        try {
            delete apiContactsList;
        } catch(Exception e) {
            throw e;
        }
    }
}
