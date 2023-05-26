import { LightningElement ,track,wire,api} from 'lwc';
import progressBarDetail from '@salesforce/apex/Rewards.progressBarDetail';

const ORDERED = 'Ordered';
const IN_TRANSIT = 'In Transit';
const DELIVERED = 'Delivered';

export default class ProgressBar extends LightningElement {
    @api recordId;
    @track receivedStatus;

    get currentStep() {
        if (this.receivedStatus && this.receivedStatus.includes(DELIVERED)) {
            return DELIVERED;
        } else if (this.receivedStatus && this.receivedStatus.includes(IN_TRANSIT)) {
            return IN_TRANSIT;
        } else {
            return ORDERED;
        }
    }

    @wire(progressBarDetail,{rewardId:'$recordId'})
    wiredProgress({data,error}){
        console.log('Inside the wire');
        if(data){
            this.receivedStatus = Array.from(new Set(data.map(rewardStatus => rewardStatus.Status__c)))
            console.log('The reward Id is' + this.recordId)
            console.log('The status is '+ this.receivedStatus)
        }
        else if (error) {
            this.error = error;
            console.log('The error is ', error);
        }
    }
}