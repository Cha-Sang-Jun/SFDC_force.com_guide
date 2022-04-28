global with sharing class remote_controller {
    /**
* Webkul Software.
*
* @category  Webkul
* @author    Webkul
* @copyright Copyright (c) 2010-2016 Webkul Software Private Limited (https://webkul.com)
* @license   https://store.webkul.com/license.html
*/
    public remote_controller() {}  // empty constructor    
    
    @RemoteAction // the function to be called in remote action should use this annotation
    global static List<Contact> getcon() {

        //function should be static and global else it will throw error
        List<Contact> con = [SELECT id,name FROM contact limit 5];

        if(con!=null && !con.isEmpty()){        
            return con;        

        } else {        
            return new List<contact>();       

        }
    }
}