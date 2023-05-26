import { LightningElement, wire, api } from 'lwc';
import fetchEmpBadge from '@salesforce/apex/FetchEmployeeBadge.fetchEmpBadge';

export default class DiplayEmployee extends LightningElement {
    //@api recordId;

    @wire(fetchEmpBadge)
    badges;

    // connectedCallback() {
    //     // Pass the record Id to the controller method to fetch employee badges for that record
    //     fetchEmpBadge({ recordId: this.recordId })
    //         .then(result => {
    //             this.badges = result;
    //         })
    //         .catch(error => {
    //             console.error(error);
    //         });
    // }

}