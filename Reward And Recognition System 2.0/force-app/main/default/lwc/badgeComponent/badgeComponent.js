import { LightningElement, wire, track } from 'lwc';
import getBadges from '@salesforce/apex/FetchEmployeeBadge.getBadges';
import { NavigationMixin } from 'lightning/navigation';
import fetchEmpInBadge from '@salesforce/apex/FetchEmployeeBadge.fetchEmpInBadge'

export default class BadgeComponent extends NavigationMixin(LightningElement) {
    @track allBadgeList = [];
    @track employeeInBadge=[];
    empBadgeMap = new Map();

    @wire(fetchEmpInBadge)
    empInBadge({data,error}){
        if(data){
            this.employeeInBadge=data.map(ele=>{
                return{
                    badgeId:ele.Assigned_Badge__c,
                    employeeCount:ele.employeeCount
                }
            });
            // console.log('the employee uder badge is ',JSON.stringify(this.employeeInBadge))
            this.employeeInBadge.forEach((ele)=>{
                this.empBadgeMap.set(ele.badgeId,ele.employeeCount);
            });
            console.log('the Employee count map is ',this.empBadgeMap);

        } else if(error){
            console.log('this is the error in employee under badge ',error);
        }
    }

    @wire(getBadges)
    wiredBadges({ data, error }) {
        if (data) {
            this.allBadgeList = data.map(badge => ({
                Id: badge.Id,
                Name: badge.Name,
                Category: badge.Category__r.Name,
                ImageUrl: badge.Image__c,
                EmployeeCount:this.empBadgeMap.get(badge.Id)

            })
            );
            this.allBadgeList=this.allBadgeList.sort((a,b)=>{
                return b.EmployeeCount-a.EmployeeCount
            })
            // console.log('All Badge list is ' + JSON.stringify(this.allBadgeList));
        } else if (error) {
            console.log(error);
        }
    }


    handleRedirect(event) {
        const param = event.currentTarget.getAttribute('value');
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: `/files?param=${param}`
            }
        });
    }


}