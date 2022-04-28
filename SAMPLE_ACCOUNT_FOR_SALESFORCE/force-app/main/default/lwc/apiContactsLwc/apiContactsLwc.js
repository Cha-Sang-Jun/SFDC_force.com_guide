import { LightningElement, api, wire, track } from 'lwc';
import insertData from '@salesforce/apex/ApiContactsClass.insertData';
import deleteData from '@salesforce/apex/ApiContactsClass.deleteData';


export default class ApiContactsLwc extends LightningElement {

    @track
    result;
    error;

    handleInsert() {
        insertData()
            .then(result => {
                this.result = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error =error;
                this.result = undefined;
            })
    }

    handleDelete() {
        deleteData()
            .then(result => {
                this.result = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.result = undefined;
            })
    }
}