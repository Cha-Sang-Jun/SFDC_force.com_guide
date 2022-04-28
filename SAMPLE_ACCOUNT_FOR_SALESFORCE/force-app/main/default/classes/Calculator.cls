/**
 * Mission : 문자열 계산기
 * 요구사항 - 문자열은 숫자, 사칙연산 기호, 공백이 사용된다.
 *          - 문자열은 '1+1', '1+3' 과 같은 형태로 주어지며 연산자는 1개만 포함된다.
 *          - 숫자로 사용되는 문자열의 범위는 자연수이다.
 * 
 * 예상결과 - 제공된 문자열이 계산된 결과가 숫자로 반환된다. ex) input : '1+6' => output : 7
 */

public with sharing class Calculator {

    /**
     * 1. 사칙연산 메소드를 각각 만들어 놓고(O)
     * 2. 받은 문자열의 사칙연산 기호에 따라 조건문을 만든다.(O)
     * 3. 공백을 제거하고 문자열 안의 숫자값을 계산해서 리턴(O)
     * 
     * 추가 -> 숫자 값이 한자리수가 아닐 때?
     */


    // 사칙연산 문자열 (숫자, 사칙연산 기호, 공백 포함)
    // String testStr = ' 3 - 2 ';
    
    Integer x;
    Integer y;

    public Calculator() {
        System.debug(calculate(' 13+ 14'));
        System.debug(calculate(' 3 - 4'));
        System.debug(calculate(' 3 * 4'));
        System.debug(calculate(' 6/2 '));

        System.debug(calculate('13+14'));
        System.debug(calculate('13 +14'));
        System.debug(calculate('13 + 14'));
        System.debug(calculate('13 + 14 '));
        System.debug(calculate(' 13 + 14 '));
        System.debug(calculate('4-3'));
        System.debug(calculate('4-4'));
        System.debug(calculate('4-5'));

        System.debug(calculate('4*5'));
    }
    
    public Integer calculate(String testStr) {

        String temp = testStr.replace(' ','');

        Integer match; 

        Integer indexOf = indexOf(temp);

        x = Integer.valueOf(temp.substring(0,indexOf));
        y = Integer.valueOf(temp.substring((indexOf+1),temp.length()));

        if(temp.contains('+') == true) {
           return plus(x,y);
        } else if (temp.contains('-') == true) {
            return minus(x,y);
        } else if (temp.contains('*') == true) {
            return multiply(x,y);
        } else if (temp.contains('/') == true) {
            return divide(x,y);
        } else {
            return null;
        }
    }

    
    public Integer plus(Integer x, Integer y) {
        return x + y;
    }

    public Integer minus(Integer x, Integer y) {
        return x - y;
    }

    public Integer multiply(Integer x, Integer y) {
        return x * y;
    }

    public Integer divide(Integer x, Integer y) {
        return x / y;
    }

    public Integer indexOf(String temp) {

        if(temp.contains('+') == true ) {
            return temp.indexOf('+');
        } else if(temp.contains('-') == true) {
            return temp.indexOf('-');
        } else if(temp.contains('*') == true) {
            return temp.indexOf('*');
        } else if(temp.contains('/') == true) {
            return temp.indexOf('/');
        } else {
            return -1;
        }
    }
}