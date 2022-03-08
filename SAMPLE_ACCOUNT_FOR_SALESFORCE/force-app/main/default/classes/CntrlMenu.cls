/**
 * @description 메뉴 화면 컨트롤러
 */
public with sharing class CntrlMenu {

    /**
     * @description 현재 화면의 URL
     */
    public String currentUrl {get;set;}

    /**
     * @description 생성자
     */
    public CntrlMenu() {

        // 현재 화면의 URL 얻기
        currentUrl = removeUrlParameter(System.currentPageReference().getUrl());
    }

    /**
     * @description URL에서 파라미터를 빼내는 메서드
     * @param url URL
     * @return 가공 후의 URL
     */
    public String removeUrlParameter(String url) {

        if (url == null) {

            return null;
        }

        return url.substringBefore('?');
    }
}