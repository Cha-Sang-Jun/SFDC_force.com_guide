/**
 * @description 회원 편집 화면 컨트롤러
 */
public class CntrlMemberEdit {

    /**
     * @description 이전 화면 URL
     */
    public String retUrl { get; set; }

    /**
     * @description 저장 후에 되돌아갈 화면URL
     */
    public String saveUrl { get; set; }

    /**
     * @description 회원
     */
    public Member__c member { get; set; }

    /**
     * @description 대여 중인 도서 목록
     */
    public List<Book__c> borrowBookList { get; set; }

    /**
     * @description 선택 항목 타입의 선택지 리스트
     */
    public List<SelectOption> isLentalSelItems { get; set; }    // 대여 유무의 선택지

    /**
     * @description 생성자
     */
    public CntrlMemberEdit() {

        // 회원 습득
        member = getMember();

        if (member == null) {
            // 회원 신규 등록

            member = new Member__c();
        }

        // URL파라미터에서 이전 화면 URL 습득
        retUrl = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_RET_URL);

        // URL파라미터에서 저장 후 되돌아갈 화면 URL 습득
        saveUrl = ApexPages.currentPage().getParameters().get(ConstUrlParameter.PARAM_NAME_SAVE_URL);

        // 선택 항목 타입의 선택지 습득
        isLentalSelItems = getIsLentalItems();      // 대여 유무

        // 대여중인 도서목록 습득
        borrowBookList = getBorrowBookList();
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

            DaoMember.upsertData(new List<Member__c>{ member });

        } catch (Exception e) {

            System.debug('[CntrlMemberEdit_save] ' + e.getStackTraceString());
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
        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_MEMBER_ID, member.Id);

        return nextPage;
    }

    /**
     * @description [취소] 버튼 처리 메서드
     * @return 이전 화면으로 전환
     */
    public PageReference cancel() {

        PageReference nextPage = new PageReference(retUrl);

        nextPage.getParameters().put(ConstUrlParameter.PARAM_NAME_MEMBER_ID, member.Id);

        return nextPage;
    }

    /**
     * @description 화면에서 입력한 정보 체크
     */
    private Boolean checkInput() {

        Boolean result = false;

        if (String.isBlank(member.MemberNo__c)) {
            // 회원 번호 미입력

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[회원 번호]을 입력해주세요.'));
            result = true;
        }

        if (String.isBlank(member.Name)) {
            // 회원명 미입력

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[회원명]을 입력해주세요.'));
            result = true;
        }

        if (member.IsLental__c != null) {
            // 대여 유무

            if (member.IsLental__c == false && !borrowBookList.isEmpty()) {
                // 대여 유무가 "미대여" 인데, 대여 중인 도서 목록이 존재하는 경우

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[대여 유무]: 대여 중인 도서가 존재하기 때문에 "미대여"선택이 불가능합니다.'));
                result = true;

            } else if (member.IsLental__c == true && borrowBookList.isEmpty()) {
                // 대여 유무가 "대여중" 인데, 대여 중인 도서 목록이 존재하지 않는 경우

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '[대여 유무]: 대여 중인 도서가 없기 때문에 "대여중"선택이 불가능합니다.'));
                result = true;
            }
        }

        return result;
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

            return null;
        }

        return memberList.get(0);
    }

    /**
     * @description 회원이 대여 중인 도서 목록 습득
     * @return 대여 중인 도서 목록
     */
    private List<Book__c> getBorrowBookList() {

        List<Book__c> bookList = new List<Book__c>();

        if (String.isBlank(member.Id)) {
            
            return bookList;
        }

        // 회원ID를 참조하고있는 도서 리스트 습득
        // 도서 개체에서 해당 도서를 대여중인 회원의 ID를 참조(조회관계)
        bookList = DaoBook.findByMemberId(new Set<ID>{ member.Id });

        return bookList;
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