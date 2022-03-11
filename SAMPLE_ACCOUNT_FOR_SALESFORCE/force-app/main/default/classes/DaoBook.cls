/**
 * @description 도서 개체에 접근하기 위한 Dao
 */
public with sharing class DaoBook {

    /**
     * @description 도서ID에 해당하는 도서 SELECT
     * @param bookIds 도서 번호의 Set
     * @return 도서 리스트
     */
    public static List<Book__c> findById(ID bookId) {

        List<Book__c> bookList = [
            SELECT
            	Id,
            	Name,
            	BookNo__c,
            	BookType__c,
            	Author__c,
            	Publisher__c,
                IsLent__c,
                LenderNo__c,
                LenderName__c,
                Lender__c,
// 조회 관계로 참조하고 있는 개체의 레코드를 참조하는 방법
// : 참조레코드의 API참조명에서 __c를 __r로 바꾸고 참조 상대 레코드명을 지정
                Lender__r.MemberNo__c,
                Lender__r.Name,
                LentDate__c,
                ReturnDate__c
            FROM
            	Book__c
            WHERE
            	// SOQL에서는 변수 등을 사용하기 위해 변수의 앞에 "콜론(:)"을 붙여주어야 함
            	Id = :bookId
        ];

        return bookList;
    }

    /**
     * @description 회원ID에 해당하는 도서 SELECT
     * @param memIds 회원ID의 Set
     * @return 도서 리스트
     */
    public static List<Book__c> findByMemberId(Set<ID> memIds) {

        List<Book__c> bookList = [
            SELECT
            	Id,
            	Name,
            	BookNo__c,
            	BookType__c,
            	Author__c,
            	Publisher__c,
                IsLent__c,
                LenderNo__c,
                LenderName__c,
// 조회 관계로 참조하고 있는 개체의 레코드를 참조하는 방법
// : 참조레코드의 API참조명에서 __c를 __r로 바꾸고 참조 상대 레코드명을 지정
                Lender__c,
                Lender__r.MemberNo__c,
                Lender__r.Name,
                LentDate__c,
                ReturnDate__c
            FROM
            	Book__c
            WHERE
            	// SOQL에서는 변수 등을 사용하기 위해 변수의 앞에 "콜론(:)"을 붙여주어야 함
            	Lender__c IN :memIds
        ];

        return bookList;
    }

    /**
     * @description 화면에서 입력한 검색 조건에 해당하는 도서 레코드 SELECT
     * @param scBookNo 도서 번호
     * @param scBookName 도서명
     * @param scBookType 도서 구분
     * @param scAuthor 저자 
     * @param scPublisher 출판사
     * @return 도서 리스트
     */
    public static List<Book__c> findBySearchCondition(String scBookNo, String scBookName, String scBookType, String scAuthor, String scPublisher) {

        // 검색 조건에 해당하는 도서를 SELECT 하기 위한 SOQL 쿼리 작성
        String soql = ' SELECT '
                        + ' Id '
                        + ', Name '
                        + ', BookNo__c '
                        + ', BookType__c '
                        + ', Author__c '
                        + ', Publisher__c '
                        + ', IsLent__c '
                        + ', LenderNo__c '
                        + ', LenderName__c '
                        + ', Lender__c '
                        + ', Lender__r.Name '
                        + ', Lender__r.MemberNo__c '
                        + ', LentDate__c '
                        + ', ReturnDate__c '
                    + ' FROM '
                        + ' Book__c ';

        // SOQL 동적 쿼리를 만들기 위한 WHERE문 작성
        String soqlWhere = '';

        if (String.isNotBlank(scBookNo)) {
            // 검색 조건 [도서 번호]가 지정된 경우, WHERE문에 추가

            soqlWhere += ' BookNo__c = \'' + String.escapeSingleQuotes(scBookNo) + '\' AND ';
        }

        if (String.isNotBlank(scBookName)) {
            // 검색 조건 [도서명]이 지정된 경우, WHERE문에 추가

            soqlWhere += ' Name LIKE \'%' + String.escapeSingleQuotes(scBookName) + '%\' AND ';
        }

        if (String.isNotBlank(scBookType)) {
            // 검색 조건 [도서 구분]가 지정된 경우, WHERE문에 추가

            soqlWhere += ' BookType__c LIKE \'%' + String.escapeSingleQuotes(scBookType) + '%\' AND ';
        }

        if (String.isNotBlank(scAuthor)) {
            // 검색 조건 [저자]가 지정된 경우, WHERE문에 추가

            soqlWhere += ' Author__c LIKE \'%' + String.escapeSingleQuotes(scAuthor) + '%\' AND ';
        }

        if (String.isNotBlank(scPublisher)) {
            // 검색 조건 [출판사]가 지정된 경우, WHERE문에 추가

            soqlWhere += ' Publisher__c LIKE \'%' + String.escapeSingleQuotes(scPublisher) + '%\' AND ';
        }

        if (String.isNotBlank(soqlWhere)) {
            // WHERE 조건이 존재하는 경우

            // 가장 마지막에 있는 "AND"를 삭제
            soqlWhere = soqlWhere.removeEnd(' AND ');

            // WHERE 조건문을 작성
            soqlWhere = ' WHERE ' + soqlWhere;
        }

        // 도서 검색을 위한 SOQL 동적 쿼리 작성
        soql = soql + soqlWhere + ' ORDER BY BookNo__c ASC';
// System.debug('[CntrlBookSearch] soql : ' + soql);

        // SOQL 쿼리 실행, 결과 반환
        return Database.query(soql);
    }

    /**
     * @description 도서 레코드를 UPSERT
     * @param bookList 등록/편집 대상 도서 리스트
     */
    public static void upsertData(List<Book__c> bookList) {

        try {

            upsert bookList;

        } catch (Exception e) {

            throw e;
        }
    }

    /**
     * @description 도서 레코드를 DELETE
     * @param bookList 삭제 대상 도서 리스트
     */
    public static void deleteData(List<Book__c> bookList) {

        try {

            delete bookList;

        } catch (Exception e) {

            throw e;
        }
    }
}