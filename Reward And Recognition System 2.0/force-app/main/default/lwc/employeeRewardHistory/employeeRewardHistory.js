import { LightningElement , track} from 'lwc';
import getRewardHistory from '@salesforce/apex/EmployeeUnderBadge.getRewardHistory';
export default class EmployeeRewardHistory extends LightningElement {
    rewardHistory=[]

    connectedCallback(){
        getRewardHistory()
        .then(result=>{
            this.rewardHistory=result
            console.log('the reward history is ',result)
        }).catch(error=>{
            console.log('this is the error in reward history',error)
        })
    }

}