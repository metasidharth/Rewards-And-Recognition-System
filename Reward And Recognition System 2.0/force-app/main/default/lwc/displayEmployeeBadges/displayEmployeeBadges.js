import { LightningElement ,wire ,api, track} from 'lwc';
import fetchEmpBadge from '@salesforce/apex/FetchEmployeeBadge.fetchEmpBadge';
import getEmployee from '@salesforce/apex/Rewards.getEmployee'
export default class DisplayEmployeeBadges extends LightningElement {


    @api recordId;
       badgeList;
    categoryList = [];
   @track employeeIds

    connectedCallback(){
        if(this.recordId==null || this.recordId==undefined){
        getEmployee()
        .then(result=>{
           this.employeeIds=result;
            console.log('the recordId  is',this.employeeIds)

            fetchEmpBadge({employeeId:this.employeeIds})
            .then(result=>{
                this.badgeList = result;
                console.log('the badges are ',this.badgeList )
                this.categoryList = Array.from(new Set(result.map(badge => badge.Category__r.Name)));
                console.log('the category list is ',this.categoryList)
                this.error = undefined;
            }).catch(error=>{
                console.log('this is from fetchemp error',error)
                this.error = error;
                this.badgeList = undefined;
            })

        }).catch(error=>{
            this.error=error;
            console.log('the error from get employee is ',error);
        })


    }
   }



  @wire(fetchEmpBadge, { employeeId: '$recordId'})
    wiredAssignedBadges({ error, data }) {
        if(data){

            this.badgeList = data;
            console.log('the badgeList of the employeee is : ',data);
            this.categoryList = Array.from(new Set(data.map(badge => badge.Category__r.Name)));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.badgeList = undefined;
        }
        this.isLoading = false;
    }


}