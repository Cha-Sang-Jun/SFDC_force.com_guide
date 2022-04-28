({
	doSave : function(component, event, helper) {
        debugger
        var action = component.get('c.createContact'); 
        var accid = component.get('v.recordId');
        var contc = component.get('v.createContact'); 
        if(contc.FirstName === null || contc.FirstName ==='' || contc.FirstName === undefined){
            return;
        }
        action.setParams({
            con : component.get('v.createContact'),
            AccountId : component.get('v.AccountId')
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if(state === 'SUCCESS' || State === 'DRAFT' ){ 
                var responseValue = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                $A.get('e.force:refreshView').fire();
                helper.toastMsg( 'Success', 'This is a success message');
            }else if(state === 'INCOMPLETE' ){
            }else if(state === 'ERROR' ){
            }
        }, 'ALL');
        $A.enqueueAction(action);
    }
})