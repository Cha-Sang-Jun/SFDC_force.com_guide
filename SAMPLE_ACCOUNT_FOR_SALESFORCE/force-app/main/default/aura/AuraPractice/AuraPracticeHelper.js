({
    doInit : function(component, event){
        var conList;
        var action = component.get("c.getContactId");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                conList = response.getReturnValue();
            }else{
                conList = [];
            }
            component.set('v.conList', conList);
        });
        $A.enqueueAction(action);
    }
})