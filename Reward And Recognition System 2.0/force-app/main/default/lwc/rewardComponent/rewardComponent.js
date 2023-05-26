import { LightningElement, wire, track,api } from 'lwc';
import getRewards from '@salesforce/apex/Rewards.getRewardConfig';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import setEmployeeReward from '@salesforce/apex/Rewards.setEmployeeReward'
import getEmployee from '@salesforce/apex/Rewards.getEmployee'
import { loadScript } from 'lightning/platformResourceLoader';
import confettiResource from '@salesforce/resourceUrl/Confetti';
import empDetails from '@salesforce/apex/Rewards.empDetails';


export default class RewardsList extends LightningElement {
    rewardsList = [];
    @api recordId;
    @track employeeId;
   // @track buttonClass;

  connectedCallback() {
  getEmployee()
    .then(result => {
      this.employeeId = result;
      console.log('the employee Id is', result);

      empDetails({ empId: this.employeeId })
        .then(resultempDetails => {
          if (Object.keys(resultempDetails).length === 0) {
            console.log('Result is empty.');
            return;
          }
          let availablePoints = resultempDetails[0].Monetization_Points__c;
          this.disableButton(availablePoints)

        })
        .catch(error => {
          this.error = error;
          console.log('the error disable button is ', error.message || error);
        });

    })
    .catch(error => {
      this.error = error;
      console.log('the error from get employee is ', error);
    });

        // for firework animation
       Promise.all([
      loadScript(this, confettiResource)
       ]).then(() => {
       console.log('confetti.js loaded');
       }).catch(error => {
      console.log('Error loading confetti.js');
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Error loading confetti.js',
          message: error.message,
          variant: 'error',
        })
      );
       });




    }

      //disable button function
     disableButton(availablePoints){
          const buttons = Array.from(this.template.querySelectorAll('lightning-button'));
          let index=0;
          this.rewardsList.forEach(element => {
            let btn =buttons[index];
            if (element.Required_Reward_Points__c > availablePoints) {
                btn.classList.add('fade');
            }
            index++;
          // this.buttonClass = element.buttonClass;
          });
  }



    @wire(getRewards)
    wiredRewards({ error,data }) {
        if (data) {
            this.rewardsList = data;
            console.log('the reward list is '+ this.rewardsList)
        } else if (error) {
            console.log(error);
        }
    }

    showtoast(message) {
        if(message.toLowerCase().includes('cannot redeem')){
        const event = new ShowToastEvent({
            title: 'Metacube',
            message: message ,
            variant: 'error'
        });
        console.log('the event is ', event);
        this.dispatchEvent(event);
    } else{
        const event = new ShowToastEvent({
            title: 'Metacube',
            message: message ,
            variant: 'success'
        });
        console.log('the event is ', event);
        this.dispatchEvent(event);
    }

    }



    fireworks() {
    var end = Date.now() + (15 * 100);
    var interval = setInterval(function() {
      if (Date.now() > end) {
        return clearInterval(interval);
      }
      confetti({
        particleCount : 450,
        startVelocity: 30,
        spread: 360,
        ticks: 150,
        origin:{
          x: Math.random(),
          y: Math.random()
        },
      });
    }, 200);
  }


  




    handleClick(event) {
  let reward = event.target.value;

      setEmployeeReward({ employeeId: this.employeeId, reward: reward })
        .then(result => {
          console.log('this is the result from controller ', result);
          this.showtoast(result);
          empDetails({empId:this.employeeId})
          .then(result => {
            let availablePoints = result[0].Monetization_Points__c;
            this.disableButton(availablePoints)

              return;
            })
        })
        .catch(error => {
          this.error = error;
          console.log('this is the error', error);
        });

      const myEvent = new CustomEvent('redeem', { detail: reward.Required_Reward_Points__c })
      this.dispatchEvent(myEvent)

      this.fireworks();
    // })
    // .catch(error => {
    //   this.error = error;
    //   console.log('the error from get employee is ', error);
    // });
}








}




  // empDetails({ empId: this.employeeId })
  //               .then(result => {
  //                   if (Object.keys(result).length === 0) {
  //                       console.log('Result is empty.');
  //                       return;
  //                   }
  //                   let availablePoints = result[0].Monetization_Points__c;
  //                   rewardsList.forEach(element => {
  //                       if (element.Required_Reward_Points__c > availablePoints) {
  //                           this.buttonClass = 'my-custom-button fade';
  //                           console.log('faded');
  //                       }
  //                   });
  //               })
  //               .catch(error => {
  //                   this.error = error;
  //                   console.log('the error disable button is ', error);
  //               });