({
    /* doInit : function(component, event){
        alert('doInit');
    } */
    
  /*  doInit : function(component, event){
        alert('doInit');
        var action = component.get("c.initComponent");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                
            } else {
                // accList = [];
            }
        });
        $A.enqueueAction(action);
    } */
    
    doInit : function(component, event){
        var accList;
        var action = component.get("c.initComponent");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                accList = response.getReturnValue();
            }else{
                accList = [];
            }
            console.log(accList);
            component.set('v.accList', accList);
        });
        $A.enqueueAction(action);
    }
})