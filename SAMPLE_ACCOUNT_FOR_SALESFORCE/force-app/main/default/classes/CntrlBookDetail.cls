/**
 * @description 도서 상세 화면 컨트롤러
 */
public class CntrlBookDetail {

    /**
     * @description 이전 화면 URL
     */ 
    public String retUrl { get; set; }

    /**
     * @description 현재 화면 URL
     */
    public String currentUrl { get; set; }

    /**
     * @description 도서
     */
    public Book__c book { get; set; }
    
    /**
     * @description 생성자
     */
    public CntrlBookDetail() {
        
        book = getBook();

        if (book == null) {

            return;
        }

        // URL파라미터에서 이전 화면 URL 습득
        retUrl = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_RET_URL);

        // 현재 화면의 URL
        PageReference currentPage = new PageReference(UtilUrl.removeUrlParameter(System.currentPageReference().getUrl()));
        currentPage.getParameters().put(ConstUrlParameter.PARAM_NAME_BOOK_ID, book.Id);
        currentUrl = currentPage.getUrl();
    }

    /**
     * @description [편집] 버튼 처리 메서드
     * @return 도서 편집 화면으로 전환
     */
    public PageReference edit() {

        // 도서 편집 화면 정보를 습득
        PageReference nextPage = Page.BookEdit;

        // 값을 전달하기 위한 URL파라미터를 설정
        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_BOOK_ID, book.Id);
        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_RET_URL, currentUrl);

        return nextPage;
    }

    /**
     * @description [삭제] 버튼 처리 메서드
     * @return 도서 검색 화면으로 전환
     */
    public PageReference del() {

        Savepoint sp = Database.setSavepoint();

        try {

            DaoBook.deleteData(new List<Book__c>{ book });

        } catch (Exception e) {

            System.debug('[CntrlBookDetail_del] ' + e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '도서를 삭제하지 못했습니다. 이유: ' + e.getMessage()));

            // DB 롤백
            Database.rollback(sp);
            return null;
        }

        return Page.BookSearch;
    }

    /**
     * @description [돌아가기] 버튼 처리 메서드
     * @return 도서 검색 화면으로 전환
     */
    public PageReference returnPage() {

        return Page.BookSearch;
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

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '도서 정보를 불러오지 못했습니다.'));
            return null;
        }

        return bookList.get(0);
    }
}