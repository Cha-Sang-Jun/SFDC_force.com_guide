/**
 * @description 도서 편집 화면 컨트롤러
 */
public class CntrlBookEdit {

    /**
     * @description 이전 화면 URL
     */
    public String retUrl { get; set; }

    /**
     * @description 저장 후에 되돌아갈 화면URL
     */
    public String saveUrl { get; set; }

    /**
     * @description 도서
     */
    public Book__c book { get; set; }

    /**
     * @description 생성자
     */
    public CntrlBookEdit() {

        // 도서 습득
        book = getBook();

        if (book == null) {
            // 도서 신규 등록

            book = new Book__c();
        }

        // URL파라미터에서 이전 화면 URL 습득
        retUrl = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_RET_URL);

        // URL파라미터에서 저장 후 되돌아갈 화면 URL 습득
        saveUrl = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_SAVE_URL);
    }

    /**
     * @description 표시할 도서 습득
     * @return 도서
     */
    private Book__c getBook() {

        // URL파라미터에서 도서ID를 습득
        ID bookId = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_BOOK_ID);

        // 도서ID에 해당하는 
        List<Book__c> bookList = DaoBook.findById(bookId);

        if (bookList == null || bookList.isEmpty()) {

            return null;
        }

        return bookList.get(0);
    }

    /**
     * @description [저장] 버튼 처리 메서드
     */
    public PageReference save() {

        if (checkInput()) {
            // 입력 항목 체크

            return null;
        }

        // 대여자 정보를 설정
        // ★조회 관계로 참조중인 개체의 레코드를 참조하는 방법★
        // 조회 관계 레코드의 API참조명에서 "__c" 를 "__r"로 변경한 후, 참조중인 개체에서 참조할 레코드의 API참조명을 지정
        if (String.isBlank(book.Lender__c)) {
            // 대여자가 지정되지 않은 경우, 도서의 대여자 정보를 클리어
            
            book.LenderNo__c = null;			// 회원 개체의 "회원 번호" 레코드 참조
            book.LenderName__c = null;			// 회원 개체의 "회원명" 레코드 참조

        } else {
            // 대여자가 지정된 경우, 도서의 대여자 정보를 설정

            book.LenderNo__c = book.Lender__r.MemberNo__c;		// 회원 개체의 "회원 번호" 레코드 참조
            book.LenderName__c = book.Lender__r.Name;			// 회원 개체의 "회원명" 레코드 참조
        }

        Savepoint sp = Database.setSavepoint();

        try {

            DaoBook.upsertData(new List<Book__c>{ book });

        } catch (Exception e) {

            System.debug('[CntrlBookEdit_save] ' + e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '저장에 실패했습니다. 이유 : ' + e.getMessage()));
            Database.rollback(sp);
            return null;
        }

        PageReference nextPage;

        if (String.isNotBlank(saveUrl)) {
            // 저장 후 되돌아갈 화면이 지정된 경우

            nextPage = new PageReference(saveUrl);

        } else if (String.isNotBlank(retUrl)) {
            // 이전 화면이 지정된 경우

            nextPage = new PageReference(retUrl);

        } else {
            // 지정된 화면이 없는 경우

            nextPage = Page.Menu;
        }

        // 값을 전달하기 위해 URL파라미터 설정
        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_BOOK_ID, book.Id);

        return nextPage;
    }

    /**
     * @description [취소] 버튼 처리 메서드
     * @return 이전 화면으로 전환
     */
    public PageReference cancel() {

        PageReference nextPage = new PageReference(retUrl);

        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_BOOK_ID, book.Id);

        return nextPage;
    }

    /**
     * @description 화면에서 입력한 정보 체크
     */
    private Boolean checkInput() {

        Boolean result = false;

        if (String.isBlank(book.BookNo__c)) {
            // 도서 번호 미입력

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[도서 번호]을 입력해주세요.'));
            result = true;
        }

        if (String.isBlank(book.Name)) {
            // 도서명 미입력

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[도서명]을 입력해주세요.'));
            result = true;
        }

        if (book.IsLent__c && String.isBlank(book.Lender__c)) {
            // 대여유무가 "대여중(TRUE)"인데, 대여자가 설정 되어있지 않은 경우

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[대여 유무]: 대여자 정보를 설정해주세요.'));
            result = true;
        }

        if (!book.IsLent__c && String.isNotBlank(book.Lender__c)) {
            // 대여유무가 "미대여(FALSE)"인데, 대여자가 설정 되어있는 경우

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[대여 유무]: 대여자 정보가 설정되어 있기 때문에, "미대여"는 선택할 수 없습니다.'));
            result = true;
        }

        return result;
    }
}