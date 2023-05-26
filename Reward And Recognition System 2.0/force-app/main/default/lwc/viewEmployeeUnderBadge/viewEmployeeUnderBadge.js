import { LightningElement, wire,track } from 'lwc';
import getEmployee from '@salesforce/apex/EmployeeUnderBadge.getEmployee';
import getBadge from '@salesforce/apex/EmployeeUnderBadge.getBadge'
export default class MyComponent extends LightningElement {
  employeeList = [];
  currentBadge
 @track noOfEmployees
 @track topEmployeeList=[]
 // for view all button visibility
  @track isHidden =false
  connectedCallback() {
    const searchParams = new URLSearchParams(window.location.search);
    const paramValue = searchParams.get('param');

    getEmployee({ badgeId: paramValue })
      .then(result => {
         let rank = 1;
        this.employeeList = result.map(emp => ({
          rank: rank++,
          Employee__r: emp.Employee__r,
        
          Total_Points__c: emp.Total_Points__c,
          Category__r: emp.Category__r,
          Assigned_Badge__r: emp.Assigned_Badge__r,
          Id: emp.Id
        }));

        if(this.employeeList.length<=10){
            this.isHidden=true
        }
          // Get the top 10 employees
          this.noOfEmployees=this.employeeList.length
         this.topEmployeeList = this.employeeList.slice(0, 10);
        console.log('the employee name  is: ', this.employeeList.Employee__r);
      })
      .catch(error => {
        console.log('the error is: ', error);
      });


      getBadge({currentBadgeId:paramValue})
      .then(result=>{
        this.currentBadge=result[0]
        console.log('the result is ',result[0])
        console.log('the current badge is ',this.currentBadge)
      }).catch(error=>{
        console.log('the error from get badge is ',error)
      });


  }

  handleViewAll(){
    this.topEmployeeList = this.employeeList
     this.isHidden=true
  }

}