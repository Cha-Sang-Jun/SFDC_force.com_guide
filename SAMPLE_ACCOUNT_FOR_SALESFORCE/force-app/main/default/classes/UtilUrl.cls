/**
 * @description URL관련 유틸리티 클래스
 */
public with sharing class UtilUrl {

    /**
     * @description URL에서 파라미터를 빼내는 메서드
     * @param url URL
     * @return 가공 후의 URL
     */
    public static String removeUrlParameter(String url) {

        if (url == null) {

            return null;
        }

        return url.substringBefore('?');
    }
}