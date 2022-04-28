import { LightningElement, api, wire, track } from 'lwc';
import insertBook from '@salesforce/apex/CntrlBookList.insertBook';
import getBookList from '@salesforce/apex/CntrlBookList.getBookList';
import selectById from '@salesforce/apex/CntrlBookList.selectById';
import deleteBook from '@salesforce/apex/CntrlBookList.deleteBook';
import ID_FIELD from '@salesforce/schema/Book__c.Id';
import Name_FIELD from '@salesforce/schema/Book__c.Name';
import BookNo__c_FIELD from '@salesforce/schema/Book__c.BookNo__c';
import BookType__c_FIELD from '@salesforce/schema/Book__c.BookType__c';
import { updateRecord } from 'lightning/uiRecordApi';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

// Define row actions
const actions = [{ label: 'View', name: 'view' }, { label: 'Update', name: 'edit' }, { label: 'Delete', name: 'delete' }];

export default class LwcBookDetail extends NavigationMixin(LightningElement) {
    // disabled = false;

    @api
    recordId;
    disabled;

    @track
    result;
    error;

    // CntrlBookList 의 selectById() 의 return 값을 book에 담는다
    @wire(selectById)
    book;


    // Define datatable columns with row actions
    columns = [
        { label: '책 이름', fieldName: 'Name', type: 'text' },
        { label: '번호', fieldName: 'BookNo__c', type: 'text' },
        { label: '장르', fieldName: 'BookType__c', type: 'text' },
        { type: 'action', typeAttributes: { rowActions: actions, menuAlignment: 'right' }, },

    ];

    // handleInsert() : insertBook의 book 객체에 담을 필드 값 설정?
    @track
    rec = {
        Name: Name_FIELD,
        BookNo__c: BookNo__c_FIELD,
        BookType__c: BookType__c_FIELD
    };

    @track
    showLoadingSpinner = false;
    // recordId;
    refreshTable;
    subscription = {};
    CHANNEL_NAME = '/event/RefreshDataTable__e';

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    connectedCallback() {
        subscribe(this.CHANNEL_NAME, -1, this.handleEvent).then(response => {
            console.log('Successfully subscribed to channel');
            this.subscription = response;
        });

        onError(error => {
            console.error('Received error from server: ', error);
        });
    }

    handleEvent = event => {
        const refreshRecordEvent = event.data.payload;
        if (refreshRecordEvent.RecordId__c === this.recordId) {
            this.recordId = '';
            return refreshApex(this.refreshTable);
        }
    }

    disconnectedCallback() {
        unsubscribe(this.subscription, () => {
            console.log('Successfully unsubscribed');
        });
    }

    // ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    @wire(getBookList)
    wiredData({ error, data }) {
        if (data) {
            this.result = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.result = undefined;
        }
    }

    handleRowActions(event) {
        try {
            const actionName = event.detail.action.name;
            const row = event.detail.row;

            switch (actionName) {
                case 'view':
                    this[NavigationMixin.Navigate]({

                        type: 'standard__recordPage',
                        attributes: {
                            recordId: row.Id,
                            objectApiName: 'Book__c',
                            actionName: 'view'
                        }
                    });
                    break;

                case 'edit':
                    // do action
                    // this[NavigationMixin.Navigate]({

                    //     type: 'standard__recordPage',
                    //     attributes: {
                    //         recordId: row.Id,
                    //         objectApiName: 'Book__c',
                    //         actionName: 'edit'
                    //     }
                    // });
                    this.selectById(row);
                    break;

                case 'delete':
                    this.deleteBook(row);
                    break;
            }
        } catch (error) {
            console.log(error);
        }
    }

    selectById(currentRow) {
        this.showLoadingSpinner = true;
        selectById({ recordId : currentRow.Id}).then(result => {
            this.showLoadingSpinner = false;
            this.book = {data: result};
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'selected',
                varinat: 'success'
             }));
             return refreshApex(this.refreshTable);
        }).catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!',
                message: JSON.stringify(error),
                variant: 'error'
            }));
        });
    }

    deleteBook(currentRow) {
        this.showLoadingSpinner = true;
        deleteBook({ book: { Id: currentRow.Id } }).then(result => {
            window.console.log('result : ' + result);
            this.showLoadingSpinner = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: currentRow.Name + 'book deleted',
                variant: 'success'
            }));
            history.go(0);
            return refreshApex(this.refreshTable);
        }).catch(error => {
            window.console.log('Error => ' + error);
            this.showLoadingSpinner = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!',
                message: JSON.stringify(error),
                variant: 'error'
            }));
        });
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    handleInsert() {
        insertBook({ book: this.rec })
            .then(result => {
                this.message = result;
                this.error = undefined;
                if (this.message != undefined) {
                    this.rec = {};
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Book inserted',
                            variant: 'success',
                        }),
                        history.go(0)
                    );
                }
            })
            .catch(error => {
                this.error = error;
                this.message = undefined;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }

    // ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    handleChange(event) {
        if (!event.target.value) {
            event.target.reportValidity();
            this.disabled = true;
        } else {
            this.disabled = false;
        }
    }

    updateBook() {
        try {
            // const allValid = [...this.template.querySelectorAll('lightning-input')]
            //     .reduce((validSoFar, inputFields) => {
            //         inputFields.reportValidity();
            //         return validSoFar && inputFields.checkValidity();
            //     }, true);

            if (true) {
                const fields = {};
                fields[ID_FIELD.fieldApiName] = this.book.data.Id;
                fields[Name_FIELD.fieldApiName] = this.template.querySelector("[data-field='Name']").value;
                // fields[Name_FIELD.fieldApiName] = this.book.data.Name;
                fields[BookNo__c_FIELD.fieldApiName] = this.template.querySelector("[data-field='BookNo__c']").value;
                fields[BookType__c_FIELD.fieldApiName] = this.template.querySelector("[data-field='BookType__c']").value;

                const recordInput = { fields };

                updateRecord(recordInput)
                    .then(() => {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'updated',
                                variant: 'success'
                            })
                        );
                        history.go(0);
                        return refreshApex(this.book);
                    })
                    .catch(error => {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error creating record',
                                message: error.body.message,
                                variant: 'error'
                            })
                        );
                    });
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Something is wrong',
                        message: 'Check your input and try again.',
                        variant: 'error'
                    })
                );
            }
        } catch (error) {
            console.log(error);
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////////

    handleNameChange(event) {
        this.rec.Name = event.target.value;
    }

    handleBookNoChange(event) {
        this.rec.BookNo__c = event.target.value;
    }

    handleBookTypeChange(event) {
        this.rec.BookType__c = event.target.value;
    }

}