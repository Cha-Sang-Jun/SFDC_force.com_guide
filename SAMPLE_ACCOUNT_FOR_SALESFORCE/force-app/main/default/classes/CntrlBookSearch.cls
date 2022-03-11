/**
 * @description 도서 검색 화면 컨트롤러
 */
public class CntrlBookSearch {

    /**
     * @description 이전 화면 URL
     */
    public String retUrl { get; set; }

    /**
     * @description 현재 화면의 URL
     */
    public String currentUrl { get; set; }

    /**
     * @description 편집 화면에서 저장 후에 돌아올 URL (파라미터 용)
     */
    public String saveUrl { get; set; }

    /**
     * @description 검색 결과가 0건일 때 표시할 메시지
     */
    public String blankMsg { get; set; }

    /**
     * @description 도서 검색 결과
     */
    public List<Book__c> srchRsltBookList { get; set; }

    /**
     * @description 검색 조건
     */
    public String srchCndtnBookNo { get; set; }     // 도서 번호
    public String srchCndtnBookName { get; set; }   // 도서명
    public String srchCndtnBookType { get; set; }   // 도서 구분
    public String srchCndtnAuthor { get; set; }     // 저자
    public String srchCndtnPublisher { get; set; }  // 출판사
    public String srchCndtnIsLental { get; set; }   // 대여 유무

    /**
     * @description 선택 항목 타입의 선택지 리스트
     */
    public List<SelectOption> bookTypeSelItems { get; set; }    // 도서 구분의 선택지
    public List<SelectOption> isLentalSelItems { get; set; }    // 대여 유무의 선택지

    /**
     * @description 생성자
     */
    public CntrlBookSearch() {

        // URL파라미터로부터 이전 화면 URL
        retUrl = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_RET_URL);

        // 현재 화면의 URL 습득
        currentUrl = UtilUrl.removeUrlParameter(System.currentPageReference().getUrl());

        // 편집 화면에서 저장 후에 돌아올 화면의 URL을 설정
        saveUrl = currentUrl;

        // 검색 결과 리스트를 초기화
        srchRsltBookList = new List<Book__c>();

        // 선택 항목 타입의 선택지 습득
        bookTypeSelItems = getBookTypeItems();      // 도서 구분
        isLentalSelItems = getIsLentalItems();      // 대여 유무
    }

    /**
     * @description 검색 버튼 처리 메서드
     */
    public void search() {

        // 검색 조건에 해당하는 도서 레코드 습득, 검색 조건이 하나도 지정되지 않은 경우, 전체 도서 검색
        srchRsltBookList = DaoBook.findBySearchCondition(srchCndtnBookNo, srchCndtnBookName, srchCndtnBookType, srchCndtnAuthor, srchCndtnPublisher);
    }

    /**
     * @description [도서 추가]버튼 처리 메서드
     */
    public PageReference newBook() {

        // 도서 편집 화면 정보를 습득
        PageReference nextPage = Page.BookEdit;

        // // 값을 전달하기 위한 URL파라미터를 설정
        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_RET_URL, currentUrl);
        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_SAVE_URL, currentUrl);

        return nextPage;
    }

    /**
     * @description [돌아가기]버튼 처리 메서드
     * @return 이전 화면으로 전환
     */
    public PageReference returnPage() {

        // 이전 화면 URL을 통해 이전 화면으로 전환
        return Page.Menu;
    }

    /**
     * @description 선택 항목 타입의 선택지 습득
     * @return 도서 구분의 선택지
     */
    private List<SelectOption> getBookTypeItems() {

        List<SelectOption> bookTypeSelList = new List<SelectOption>();

        // 도서 개체의 "도서 구분" 필드 정보를 습득
        Schema.DescribeFieldResult fieldResult = Book__c.BookType__c.getDescribe();
        List<Schema.PicklistEntry> pickListEntry = fieldResult.getPicklistValues();

        // 첫 번째 선택지에 '공백'을 추가
        bookTypeSelList.add(new SelectOption('', ''));

        for (Schema.PicklistEntry pick: pickListEntry) {

            // 선택 항목에 설정된 선택지를 선택리스트에 저장 <API참조명, 명칭>
            bookTypeSelList.add(new selectOption(pick.getValue(), pick.getLabel()));
        }

        return bookTypeSelList;
    }

    /**
     * @description 선택 항목 타입의 선택지 습득
     * @return 대여 유무 구분의 선택지
     */
    private List<SelectOption> getIsLentalItems() {

        List<SelectOption> isLentalSelList = new List<SelectOption>();

        // 첫 번째 선택지에 '공백'을 추가
        isLentalSelList.add(new SelectOption('', ''));
        isLentalSelList.add(new SelectOption('false', '미대여'));
        isLentalSelList.add(new SelectOption('true', '대여중'));

        return isLentalSelList;
    }
}