({
    toastMsg : function( strType, strMessage ) { 
        var showToast = $A.get("e.force:showToast");  
        showToast.setParams({
            message : strMessage, 
            type : strType,
            duration : 5000,
            mode : 'dismissible' 
        });  
        showToast.fire(); 
    }
})