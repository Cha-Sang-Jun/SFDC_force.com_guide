/**
 * @description csv 출력 컨트롤러
 */

public with sharing class CntrlCsvDownload {

    // 개행코드
    final String CSV_LINEFEED = '\r\n';

    /**
     * @description csv 출력 관련 변수
     */

    public String csvFileName { get ; set; }    // csv파일명
    public String csvHeader { get; set; }       // csv헤더
    public List<String> csvBodyList { get; set; }  // csv본문

    /**
     * @description 생성자
     */
    public CntrlCsvDownload() {

        csvBodyList = new List<String>();
    }

    /**
     * @description csv 출력
     */
    public PageReference exportToCsv(){

        // 파일명 : Member[년월일].csv
        csvFileName = 'Member' + Datetime.now().format('yyyyMMdd') + '.csv';

        // csv 헤더 설정
        csvHeader = '회원번호, 회원명, 회원등록일, 전화번호, 이메일주소' + CSV_LINEFEED;

        // 회원 레코드 습득
        List<Member__c> memberList = [SELECT Id, Name, MemberNo__c, RegistDate__c, Phone__c, Email__c FROM Member__c];

        for(Member__c member : memberList) {

            // csv 본문 생성
            String body = convertNullToBlank(member.MemberNo__c)
                    + ',' + convertNullToBlank(member.Name)
                    + ',' + convertNullToBlank(member.RegistDate__c)
                    + ',' + convertNullToBlank(member.Phone__c)
                    + ',' + convertNullToBlank(member.Email__c);

            // csv 본문에서 행의 마지막에 개행코드를 추가(행 구분)
            body += CSV_LINEFEED;

            // csv 출력에 사용할 본문 리스트에 추가
            csvBodyList.add(body);
        }
        
        // csv 출력 템플릿 페이지 호출
        return Page.ExportToCsvTemplate.setRedirect(false);
        // return null;
    }

    /** 
     * @description csv 본문 출력시, null을 공백문자로 표시하기 위해 치환
     * @param str 확인할 문자열
     * @return 공백 또는 문자열
     */
    private String convertNullToBlank(String str) {

        return (String.isBlank(str)) ? '' : str;
    }

    /**
     * @description csv 본문 출력시, null을 공백문자로 표시하기 위해 치환
     * @param dt 확인할 날짜 변수
     * @return 공백 또는 날짜
     */

     private String convertNullToBlank(Date dt) {

        // 날짜(년월일) 또는 공백
        // String.leftPad(prm1:문자수, prm2: 남은 문자수가 빈칸인 경우, 채워 넣을 지정 문자)
        return (dt == null) ? '' : String.valueOf(dt.year()) + String.valueOf(dt.month()).leftPad(2,'0') + String.valueOf(dt.day()).leftPad(2,'0');
     }
    }