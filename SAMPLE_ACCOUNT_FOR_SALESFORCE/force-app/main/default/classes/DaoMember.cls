/**
 * @description 회원 개체에 접근하기 위한 Dao
 */
public class DaoMember {

    /**
     * @description 회원 ID에 해당하는 회원 레코드 SELECT
     * @param memIds 회원ID
     * @return 회원 리스트
     */
    public static List<Member__c> findById(Set<ID> memIds) {

        List<Member__c> memList = [
            SELECT
                Id,
                Name,
                IsLental__c,
                ReturnBook__c,
                Email__c,
                Phone__c,
                RegistDate__c,
                MemberNo__c
            FROM
                Member__c
            WHERE
                ID IN :memIds
        ];

        return memList;
    }

    /**
     * @description 화면에서 입력한 검색 조건에 해당하는 회원 레코드 SELECT
     * @param scMember 검색 조건용 회원 변수
     * @param scIsLental 대여 유무  
     * @return 회원 리스트
     */
    public static List<Member__c> findBySearchCondition(Member__c scMember, String scIsLental) {

        // 검색 조건에 해당하는 회원을 SELECT 하기 위한 SOQL 쿼리 작성
        String soql = ' SELECT '
                        + ' Id '
                        + ', Name '
                        + ', IsLental__c '
                        + ', ReturnBook__c '
                        + ', Email__c '
                        + ', Phone__c '
                        + ', RegistDate__c '
                        + ', MemberNo__c '
                    + ' FROM '
                        + ' Member__c ';

        // SOQL 동적 쿼리를 만들기 위한 WHERE문 작성
        String soqlWhere = '';

        if (String.isNotBlank(scMember.MemberNo__c)) {
            // 검색 조건 [회원 번호]가 지정된 경우, WHERE문에 추가

            soqlWhere += ' MemberNo__c = \'' + String.escapeSingleQuotes(scMember.MemberNo__c) + '\' AND ';
        }

        if (String.isNotBlank(scMember.Name)) {
            // 검색 조건 [회원명]이 지정된 경우, WHERE문에 추가

            soqlWhere += ' Name LIKE \'%' + String.escapeSingleQuotes(scMember.Name) + '%\' AND ';
        }

        if (scMember.RegistDate__c != null) {
            // 검색 조건 [회원 등록일]이 지정된 경우, WHERE문에 추가

            soqlWhere += ' RegistDate__c = ' + String.escapeSingleQuotes(String.valueOf(scMember.RegistDate__c)) + ' AND ';
        }

        if (String.isNotBlank(scMember.Phone__c)) {
            // 검색 조건 [전화 번호]가 지정된 경우, WHERE문에 추가

            soqlWhere += ' Phone__c LIKE \'%' + String.escapeSingleQuotes(scMember.Phone__c) + '%\' AND ';
        }

        if (String.isNotBlank(scMember.Email__c)) {
            // 검색 조건 [이메일 주소]가 지정된 경우, WHERE문에 추가

            soqlWhere += ' Email__c LIKE \'%' + String.escapeSingleQuotes(scMember.Email__c) + '%\' AND ';
        }

        if (String.isNotBlank(scIsLental)) {
            // 검색 조건 [대여 유무]가 지정된 경우, WHERE문에 추가

            scMember.IsLental__c = Boolean.valueOf(scIsLental);

            soqlWhere += ' IsLental__c = ' + scMember.IsLental__c + ' AND ';
        }

        if (String.isNotBlank(scMember.ReturnBook__c)) {
            // 검색 조건 [이메일 주소]가 지정된 경우, WHERE문에 추가

            soqlWhere += ' ReturnBook__c = \'' + String.escapeSingleQuotes(scMember.ReturnBook__c) + '\' AND ';
        }

        if (String.isNotBlank(soqlWhere)) {
            // WHERE 조건이 존재하는 경우

            // 가장 마지막에 있는 "AND"를 삭제
            soqlWhere = soqlWhere.removeEnd(' AND ');

            // WHERE 조건문을 작성
            soqlWhere = ' WHERE ' + soqlWhere;
        }

        // 도서 검색을 위한 SOQL 동적 쿼리 작성
        soql = soql + soqlWhere + ' ORDER BY MemberNo__c ASC';

        // SOQL 쿼리 실행, 결과 반환
        return Database.query(soql);
    }

    /**
     * @description 회원 레코드를 UPSERT
     * @param memList 등록/편집 대상 도서 리스트
     */
    public static void upsertData(List<Member__c> memList) {

        try {

            upsert memList;

        } catch (Exception e) {

            throw e;
        }
    }

    /**
     * @description 회원 레코드를 DELETE
     * @param bookList 삭제 대상 도서 리스트
     */
    public static void deleteData(List<Member__c> memList) {

        try {

            delete memList;

        } catch (Exception e) {

            throw e;
        }
    }    
}