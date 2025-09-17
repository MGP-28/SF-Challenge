import { LightningElement, api, track } from 'lwc';
import getRelatedRecords from '@salesforce/apex/RelatedRecordsController.getRelatedRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RecordPageObjectAChildren extends LightningElement {
    @api recordId;
    @track records = [];
    @track columns = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Name', fieldName: 'Name' }
    ];
    pageNumber = 1;
    pageSize = 10;
    totalRecords = 0;
    lastRecord1 = 0;
    lastRecord2 = 0;
    maxRecords;

    get isNextDisabled() {
        return this.totalRecords < this.pageSize 
        || this.maxRecords == this.lastRecord1 + this.lastRecord2;
    }

    get isPreviousDisabled() {
        return this.pageNumber == 1;
    }

    connectedCallback() {
        this.loadRecords();
    }

    loadRecords() {
        getRelatedRecords({ recordId: this.recordId, pageNumber: this.pageNumber, pageSize: this.pageSize, lastRecord1: this.lastRecord1, lastRecord2: this.lastRecord2})
            .then(result => {
                console.log(result);
                if (result.totalRecords == 0) {
                    this.totalRecords = 0;
                    this.maxRecords = result.lastRecord1 + result.lastRecord2;
                    this.pageNumber--;
                    this.showInfoToast();
                    return;
                }
                this.records = result.records;
                this.totalRecords = result.totalRecords;
                this.lastRecord1 = result.lastRecord1;
                this.lastRecord2 = result.lastRecord2;
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleNext() {
        this.pageNumber++;
        this.loadRecords();
    }

    handlePrevious() {
        this.pageNumber--;
        this.loadRecords();
    }

    showInfoToast(){
        const evt = new ShowToastEvent({
            title: 'No more records to show',
            message: '',
            variant: 'info',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
}
