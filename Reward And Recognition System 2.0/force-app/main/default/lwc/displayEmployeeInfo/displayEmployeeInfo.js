import { LightningElement, api, wire, track } from 'lwc';
import empDetails from '@salesforce/apex/Rewards.empDetails';
import getEmployee from '@salesforce/apex/Rewards.getEmployee';

export default class DisplayEmployeeInfo extends LightningElement {


  @track employeeId;
  @track employeeDetailsList;

@track monetizationPoint;
@track redeemedPoints
  connectedCallback() {
    getEmployee()
      .then(result => {
        this.employeeId = result;
        console.log('the employee Id is', result);
        this.loadEmployeeDetails();




      })
      .catch(error => {
        this.error = error;
        console.log('the error from get employee is ', error);
      });
  }


  handleRefresh(event){
    console.log('the refresh event is fired')
   // this.loadEmployeeDetails();
   console.log('the value for monetization point in event is ',event.detail)
 if(this.monetizationPoint-event.detail>=0){
   this.monetizationPoint-=event.detail
   this.redeemedPoints+=event.detail
   }
  }

  loadEmployeeDetails() {
    if (this.employeeId) {
      empDetails({ empId: this.employeeId })
        .then(result => {
          this.employeeDetailsList = result;
          this.monetizationPoint = result[0].Monetization_Points__c;
          this.redeemedPoints= result[0].Roll_Up_Employee_Reward__c;
          console.log('employeeDetailsList is ' ,result[0]);
        })
        .catch(error => {
          console.error(error);
        });
    }
  }

}