import { LightningElement,track } from 'lwc';
import sendEmailController from '@salesforce/apex/LeaderboardData.sendEmailController'

export default class SendMailComponent extends LightningElement {
   @track emailArray=[]
   emailObj
   handleInput(event){
    this.emailObj={
        id:this.emailArray.length+1,
        email:event.target.value
    }
   }
   handleAdd(){
    console.log('the button is clicked')
    this.emailArray.push(this.emailObj);
    console.log('the email object is ',this.emailObj.id)
    console.log('the email object is ',this.emailObj.email)
    console.log('the email array is ',this.emailArray.length)
   }

   handleDelete(event) {
    const index = event.target.value;
    this.emailArray.splice(index-1, 1);
    // update the id of each email object in the array
    this.emailArray.forEach((email, i) => {
        email.id = i + 1;
        console.log('the value of i is ',i)
    });
    this.emailArray = [...this.emailArray];
    //console.log('the email is deleted', this.emailArray[index-1].email);
  }

}