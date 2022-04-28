// ({
//     helperMethod : function() {

//     }
// })

({
    doInit: function (component, event) {
        var bookList;
        var action = component.get("c.getBookList");

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                bookList = response.getReturnValue();
            } else {
                bookList = [];
            }
            component.set('v.bookList', bookList);
        });
        $A.enqueueAction(action);
    },

    toastMsg: function (strType, strMessage) {
        var showToast = $A.get("e.force:showToast");
        showToast.setParams({
            message: strMessage,
            type: strType,
            duration: 5000,
            mode: 'dismissible'
        });
        showToast.fire();
    }
})