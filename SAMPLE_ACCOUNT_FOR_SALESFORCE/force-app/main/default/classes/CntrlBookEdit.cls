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

        return result;
    }
}