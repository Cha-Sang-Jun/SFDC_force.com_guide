/**
 * @description 회원 검색 화면 컨트롤러
 */
public class CntrlMemberSearch {

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
     * @description 회원 검색 결과
     */
    public List<Member__c> srchRsltList { get; set; }

    /**
     * @description 검색 조건 설정용 회원 변수 정의
     */
    public Member__c srchCndtnMemberObj { get; set; }
    public String srchCndtnIsLental { get; set; }

    /**
     * @description 선택 항목 타입의 선택지 리스트
     */
    public List<SelectOption> isLentalSelItems { get; set; }    // 대여 유무의 선택지
    public List<SelectOption> isReturnSelItems { get; set; }    // 반납 유무의 선택지

    /**
     * @description 생성자
     */
    public CntrlMemberSearch() {

        // URL파라미터로부터 이전 화면 URL
        retUrl = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_RET_URL);

        // 현재 화면의 URL 습득
        currentUrl = UtilUrl.removeUrlParameter(System.currentPageReference().getUrl());

        // 편집 화면에서 저장 후에 돌아올 화면의 URL을 설정
        saveUrl = currentUrl;

        // 검색 결과 리스트를 초기화
        srchRsltList = new List<Member__c>();

        // 선택 항목 타입의 선택지 습득
        isLentalSelItems = getIsLentalItems();      // 대여 유무
        isReturnSelItems = getIsReturnItems();      // 반납 유무

        // 검색 조건 설정용 회원 변수 초기화
        srchCndtnMemberObj = new Member__c();
    }

    /**
     * @description 검색 버튼 처리 메서드
     */
    public void search() {

        // 검색 조건에 해당하는 회원 레코드 습득, 검색 조건이 하나도 지정되지 않은 경우, 전체 회원 검색
        srchRsltList = DaoMember.findBySearchCondition(srchCndtnMemberObj,
                                                       srchCndtnIsLental);
    }

    /**
     * @description [회원 추가]버튼 처리 메서드
     */
    public PageReference newMember() {

        // 회원 편집 화면 정보를 습득
        PageReference nextPage = Page.MemberEdit;

        // 값을 전달하기 위한 URL파라미터를 설정
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

    /**
     * @description 선택 항목 타입의 선택지 습득
     * @return 반납 유무 구분의 선택지
     */
    private List<SelectOption> getIsReturnItems() {

        List<SelectOption> isReturnSelList = new List<SelectOption>();

        // 첫 번째 선택지에 '공백'을 추가
        isReturnSelList.add(new SelectOption('', ''));
        isReturnSelList.add(new SelectOption('미대여', '미대여'));
        isReturnSelList.add(new SelectOption('미반납', '미반납'));
        isReturnSelList.add(new SelectOption('반납', '반납'));
        isReturnSelList.add(new SelectOption('연체', '연체'));

        return isReturnSelList;
    }
}