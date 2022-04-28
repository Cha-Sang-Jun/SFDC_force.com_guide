import { LightningElement, api, wire } from 'lwc';
import getContactList from '@salesforce/apex/ApexHoursDemoClass.getContactList';
import getAccountDetails from '@salesforce/apex/ApexHoursDemoClass.getAccountDetails';

export default class FirstLwcAPD extends LightningElement {
    greeting = 'Welcome to Apex Hour'
    inputText = '';

    @api message = 'this is a simple message';
    result;
    error;

    /**
     *  Get a class
     *  Create an AuraEnabled Method
     *  import the mothod in LWC
     *  use @wire to call the method // data, error
     */

    @wire(getContactList)
    wiredData({ error, data }) {
        if (data) {
            this.result = data;
            this.error = undefined;
            window.console.log(' Contact Records ', data);
        } else if (error) {
            this.error = error;
            window.console.log(' Contact Error ', error);
            this.result = undefined;
        }
    }

    // @wire(getAccountDetails)
    // wiredData({error, data}) {
    //     if (data) {
    //         this.result = data;
    //         this.error = undefined;
    //         window.console.log(' Account Records ', data);
    //     } else if (error) {
    //         this.error = error;
    //         window.console.log(' Account Error ', error);
    //         this.result = undefined;
    //     }
    // }


    handleClick(event) {
        this.inputText = event.target.value;
        window.console.log(' event.target ', event.target);
    }

    handleSubmit() {
        alert('Button Clicked');
        getAccountDetails()
            .then(result => {
                this.result = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error =error;
                this.result = undefined;
            })
    }
}