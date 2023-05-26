import { LightningElement, api,track } from 'lwc';
import getStatusHistory from '@salesforce/apex/Rewards.getStatusHistory';
export default class OrderTracking extends LightningElement {
    @api recordId
    rewardName
    @track statusHistoryList
    connectedCallback(){
      getStatusHistory({rewardId:this.recordId})
      .then(result=>{
        this.statusHistoryList=result
        console.log('the status history is ',result)
        this.rewardName=result[0].Employee_Reward__r.Earned_Reward__r.Name
      }).catch(error=>{
        console.log('the error in history is ',error)
      })
    }

}