// ({
//     myAction : function(component, event, helper) {

//     }
// })

({
    init: function (component, event, helper) {
        helper.doInit(component, event);
    },

    doSave: function (component, event, helper) {
        var insertBook;

        var insert = component.get("c.insertBook");
        var contc = component.get("v.insertBook");

        if (contc.Name === null || contc.Name === '' || contc.Name === undefined) {
            return;
        }
        
        // setParams() : 서버 측 컨트롤러에 전달할 데이터를 설정한다.
        insert.setParams({
            book: contc
        });
        
        console.log('contc : ' + contc);

        // setCallback() : 서버 측 작업이 반환된 후 호출되는 콜백 작업을 설정한다.
        // response.getState() : 서버 측 작업결과는 respnose 콜백의 인수인 변수 이다.
        // response.getState -> 서버에서 반환된 작업의 상태를 가져온다. 
        // response.getReturnValue() 서버에서 반환 된 값을 가져온다.
        
        insert.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS" || state === 'DRAFT') {
                var responseValue = response.getReturnValue();

                console.log(response.getReturnValue());

                var toastEvent = $A.get("e.force:showToast");
                $A.get('e.force:refreshView').fire();
                helper.toastMsg('Success', 'This is a success message');
            } else if (state === 'INCOMPLETE') {
            } else if (state === 'ERROR') {
            }
        }, 'ALL');
        $A.enqueueAction(insert);  
        // $A.enqueueAction() : 실행 할 작업 대기열에 서버 측 컨트롤러 작업을 추가한다.
    },

    update: function(component, event, helper) {
        var updateBook;
        var selectById;

        var update = component.get("c.updateBook");
        var contc = component.get("v.selectById");

        // if (contc.Name === null || contc.Name === '' || contc.Name === undefined) {
        //     return;
        // }
        
        update.setParams({book: contc});
        
        console.log('contc >>> ' + contc);

        update.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS" || state === 'DRAFT') {
                var responseValue = response.getReturnValue();

                console.log(response.getReturnValue());

                var toastEvent = $A.get("e.force:showToast");
                $A.get('e.force:refreshView').fire();
                helper.toastMsg('Success', 'This is a success message');
            } else if (state === 'INCOMPLETE') {
            } else if (state === 'ERROR') {
            }
        }, 'ALL');
        $A.enqueueAction(update);  
    },

    // aura:attribute 를 사용하여 구성 요소에 대한 속성을 정의하면
    // component.get 을 이용하여 속성 값을 얻을 수 있다.
    // component.set을 사용사여 속성 값을 설정 할 수있다.
    delete: function (component, event) {
        var bookList;
        var deleteBook;

        var action = component.get("c.deleteBook");

        action.setParams({ BookId: event.target.id});
        action.setCallback(this, function (response) {
            component.set("v.bookList", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    select: function (component, event) {
        var selectById;

        var select = component.get("c.selectById");
        select.setParams({ BookId: event.target.id});
        select.setCallback(this, function (response) {
            component.set("v.selectById", response.getReturnValue());
        });
        $A.enqueueAction(select);
    },

})