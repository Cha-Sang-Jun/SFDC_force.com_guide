/**
 * @description Visualforce Javascript 연동 페이지의 컨트롤러
 */

public with sharing class CntrlVfCallJs {
    
    /**
     * @description javascript 에서 호출할 변수
     */
    public String myVariable {get; set;}
    
    /**
     * @description 생성자
     */
    public CntrlVfCallJs() {

     myVariable = 'Hello World';
    }

    /**
     * @description javascript 에서 호출할 변수
     */
    public void myMethod(){
        
        // 화면에 메세지 표시
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'ApexPages 메세지 테스트'));
    }
}
