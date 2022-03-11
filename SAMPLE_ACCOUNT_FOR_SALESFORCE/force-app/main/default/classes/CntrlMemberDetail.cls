/**
 * @description 회원 상세 화면 컨트롤러
 */
public class CntrlMemberDetail {

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
    public Member__c member { get; set; }

    /**
     * @description 대여 중인 도서 목록
     */
    public List<Book__c> borrowBookList { get; set; }

    /**
     * @description 생성자
     */
    public CntrlMemberDetail() {

        member = getMember();

        if (member == null) {

            return;
        }

        // URL파라미터에서 이전 화면 URL 습득
        retUrl = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_RET_URL);

        // 현재 화면의 URL
        PageReference currentPage = new PageReference(UtilUrl.removeUrlParameter(System.currentPageReference().getUrl()));
        currentPage.getParameters().put(ConstUrlParameter.PARAM_NAME_MEMBER_ID, member.Id);
        currentUrl = currentPage.getUrl();

        // 대여중인 도서목록 습득
        borrowBookList = getBorrowBookList();
    }

    /**
     * @description [편집] 버튼 처리 메서드
     * @return 회원 편집 화면으로 전환
     */
    public PageReference edit() {

        // 도서 편집 화면 정보를 습득
        PageReference nextPage = Page.MemberEdit;

        // 값을 전달하기 위한 URL파라미터를 설정
        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_MEMBER_ID, member.Id);
        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_RET_URL, currentUrl);

        return nextPage;
    }

    /**
     * @description [삭제] 버튼 처리 메서드
     * @return 회원 검색 화면으로 전환
     */
    public PageReference del() {

        Savepoint sp = Database.setSavepoint();

        if (! (borrowBookList == null && borrowBookList.isEmpty()) ) {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '대여 중인 도서가 있기 때문에 회원 정보를 삭제할 수 없습니다.'));
            return null;
        }

        try {

            DaoMember.deleteData(new List<Member__c>{ member });

        } catch (Exception e) {

            System.debug('[CntrlMemberDetail_del] ' + e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '회원을를 삭제하지 못했습니다. 이유: ' + e.getMessage()));

            // DB 롤백
            Database.rollback(sp);
            return null;
        }

        return Page.MemberSearch;
    }

    /**
     * @description [돌아가기] 버튼 처리 메서드
     * @return 회원 검색 화면으로 전환
     */
    public PageReference returnPage() {

        return Page.MemberSearch;
    }

    /**
     * @description 표시할 회원 습득
     * @return 회원
     */
    private Member__c getMember() {

        // URL파라미터에서 회원ID를 습득
        ID memId = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_MEMBER_ID);

        // 회원ID에 해당하는 회원 습득
        List<Member__c> memberList = DaoMember.findById(new Set<ID>{ memId });

        if (memberList == null || memberList.isEmpty()) {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '회원 정보를 불러오지 못했습니다.'));
            return null;
        }

        return memberList.get(0);
    }

    /**
     * @description 회원이 대여 중인 도서 목록 습득
     * @return 대여 중인 도서 목록
     */
    private List<Book__c> getBorrowBookList() {

        // 회원ID를 참조하고있는 도서 리스트 습득
        // 도서 개체에서 해당 도서를 대여중인 회원의 ID를 참조(조회관계)
        return DaoBook.findByMemberId(new Set<ID>{ member.Id });
    }
}