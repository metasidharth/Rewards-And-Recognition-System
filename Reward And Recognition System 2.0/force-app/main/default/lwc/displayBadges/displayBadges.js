import { LightningElement, api, wire } from 'lwc';
import fetchEmpBadge from '@salesforce/apex/FetchEmployeeBadge.fetchEmpBadge';

export default class EmployeeBadges extends LightningElement {
 @api recordId; // employee's Id
 badges = [];

 // retrieve badges for the employee
 @wire(fetchEmpBadge, { employeeId: '$recordId' })
 loadBadges({ error, data }) {

  if (data) {
    this.badges=data;

   console.log( 'The badges table is '+this.badges)
  }
  else if (error) {
   console.log(error);
  }
 }

}
