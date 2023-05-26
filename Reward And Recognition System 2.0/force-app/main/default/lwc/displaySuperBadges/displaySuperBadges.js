import { LightningElement ,wire ,api, track} from 'lwc';
import fetchEmpSuperBadge from '@salesforce/apex/FetchEmployeeBadge.fetchEmpSuperBadge';
import getEmployee from '@salesforce/apex/Rewards.getEmployee'

export default class DisplaySuperBadges extends LightningElement {

    @api recordId;
    superBadgeList;
    categoryList = [];
    @track employeeIds

    connectedCallback(){
        if(this.recordId==null || this.recordId==undefined){
        getEmployee()
        .then(result=>{
           this.employeeIds=result;
            console.log('the recordId  is',this.employeeIds)

            fetchEmpSuperBadge({employeeId:this.employeeIds})
            .then(result=>{
                this.superBadgeList = result;
                console.log('the superbadges are ',this.superBadgeList )
                // console.log('Super badge img from community is ',this.superBadgeList[0].Super_Badge_Configuration__r.Super_Badge_Image__c);              
                this.categoryList = Array.from(new Set(data.map(badge => badge.Category__r.Name)));
                console.log('the category list is ',this.categoryList)
                this.error = undefined;
            }).catch(error=>{
                console.log('this is from fetchemp error',error)
                this.error = error;
                // this.badgeList = undefined;
            })

        }).catch(error=>{
            this.error=error;
            console.log('the error from get employee is ',error);
        })


    }
   }



  @wire(fetchEmpSuperBadge, { employeeId: '$recordId'})
    wiredAssignedBadges({ error, data }) {
        if(data){
            this.superBadgeList = data;
            console.log('Super Badge List is from wire is ',this.superBadgeList);
            // console.log('Super badge img from wire is ',this.superBadgeList[0].Super_Badge_Configuration__r.Super_Badge_Image__c);
            this.categoryList = Array.from(new Set(data.map(badge => badge.Category__r.Name)));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            console.log('The error is ', error);
            // this.superBadgeList = undefined;
            console.log('Super Badge list from error is ',this.superBadgeList);
        }
        this.isLoading = false;
    }

}