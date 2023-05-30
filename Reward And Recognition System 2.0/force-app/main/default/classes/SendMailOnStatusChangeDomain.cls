public class SendMailOnStatusChangeDomain  extends fflib_SObjectDomain {
    Map<String,Employee__c> employeeMap=new Map<String,Employee__c>();
    Map<String,Reward_Configuration__c> rewardMap=new Map<String,Reward_Configuration__c>();
    
    public SendMailOnStatusChangeDomain(List<Employee_Reward__c> sObjectList) {
        super(sObjectList);
        // Initialize employeeMap when constructing the domain
        for(Employee__c emp: [Select name ,Employee_Id__c , Email__c from Employee__c]){
            employeeMap.put(emp.Id,emp);          
        }
        for(Reward_Configuration__c rw: [Select Name ,Reward_Image__c from Reward_Configuration__c]){
            rewardMap.put(rw.Id,rw);
        }
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new SendMailOnStatusChangeDomain(sObjectList);
        }
    }
        
    List<Status_Tracking__c> stList=new List<Status_Tracking__c>(); 
    
    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {      
        for(Employee_Reward__c empReward:(List<Employee_Reward__c>)Trigger.new){            
            Employee_Reward__c oldRecord=(Employee_Reward__c)existingRecords.get(empReward.Id);           
            if(oldRecord.Status__c != empReward.Status__c){
                // if(Trigger.oldMap.get(empReward.Id).Status__c != Trigger.newMap.get(empReward.Id).Status__c){
                Employee__c emp= employeeMap.get(empReward.Employee__c);
                Reward_Configuration__c rwd=rewardMap.get(empReward.Earned_Reward__c);
                sendEmail(emp,rwd,empReward.Status__c);
                Status_Tracking__c st=new Status_Tracking__c();
                st.Employee_Reward__c=empReward.Id;
                st.Status__c=empReward.Status__c;
                st.Processed_Date__c=Date.today();
                stList.add(st);
            }          
        }  
        upsert stList; 
    }
    
    public override void onAfterInsert(){
        for(Employee_Reward__c empReward:(List<Employee_Reward__c>)Trigger.new){
            /*
            Employee__c emp= employeeMap.get(empReward.Employee__c);
            Reward_Configuration__c rwd=rewardMap.get(empReward.Earned_Reward__c);
            sendEmail(emp,rwd,empReward.Status__c);
			*/
            Status_Tracking__c st=new Status_Tracking__c();
            st.Employee_Reward__c=empReward.Id;
            st.Status__c=empReward.Status__c;
            st.Processed_Date__c=Date.today();
            stList.add(st);
            
        }    
        upsert stList; 
    }
    public static void sendEmail(Employee__c employee,Reward_Configuration__c reward,String status){
        List<Employee__c> hrList=[select name , Email__c  from Employee__c WHERE Designation__c like 'HR'];
        List<String> emailListString = new List<String>(); 
        for(Employee__c emp:hrList){
            if(emp.Email__c != NULL) {
                emailListString.add(String.valueOf(emp.Email__c));
            }
        }
        
        // Generate the email body for Hr  using an email template
        Messaging.SingleEmailMessage emailToHR = new Messaging.SingleEmailMessage();
        //emailToHR.setTemplateId('00X2w000000WqF9');
        emailToHR.setToAddresses(emailListString);
        emailToHR.setSubject( 'Regarding Employee Reward Status ');
        //  emailToHR.setTargetObjectId(UserInfo.getUserId());
        emailToHR.setSaveAsActivity(false);
        emailToHR.setPlainTextBody('');
        
        // Generate the HTML email body
        String htmlBodyHR = 'Dear HR,<br/><br/>';        
        htmlBodyHR += employee.Name+' ('+employee.Employee_Id__c+ ') '+' Order status for  ' + Reward.Name + ' is changed to '+ status +'<br/><br/>';
        htmlBodyHR += '<img src="' + reward.Reward_Image__c + '" alt="alternate_text" style="height: 100px; width: 100px;"> <br/><br/>';
        htmlBodyHR += 'So please look forward for sending the reward to employee <br/><br/>';
        htmlBodyHR += 'Thanks & Regards,<br/><br/>';
        htmlBodyHR += '<Sender Name>';
        htmlBodyHR += '<h2 style="color: #3da8ef;">Metacube Software Pvt. Ltd.</h2>';
        htmlBodyHR += 'SP-6, Phase IV, EPIP Sitapura, Jaipur, Rajasthan';
        
        // Set the HTML body for the email
        emailToHR.setHtmlBody(htmlBodyHR);
        
        
        // Send the email to the employee who redeemed reward
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{emailToHR});       
        List<String> EmployeeEmail=new List<String>();
        EmployeeEmail.add(employee.Email__c);
        // Generate the email body for Employee  using an email template
        Messaging.SingleEmailMessage emailToEmployee = new Messaging.SingleEmailMessage();
        //emailToEmployee.setTemplateId('00X2w000000WqF9');
        emailToEmployee.setToAddresses(EmployeeEmail);
        emailToEmployee.setSubject( 'Regarding Your Order Status');
        //  emailToEmployee.setTargetObjectId(UserInfo.getUserId());
        emailToEmployee.setSaveAsActivity(false);
        emailToEmployee.setPlainTextBody('');
        
        // Generate the HTML email body
        String htmlBodyEmployee = 'Dear Employee,<br/><br/>';        
        htmlBodyEmployee += employee.Name+' ('+employee.Employee_Id__c+ ') '+'Your order for'+ Reward.Name +' been processed to '+ status  +'. <br/><br/>';
        htmlBodyEmployee += '<img src="' + reward.Reward_Image__c + '" alt="alternate_text" style="height: 100px; width: 100px;"> <br/><br/>';
        htmlBodyEmployee += 'A heartfelt congratulations for your reward ,it will arrive soon.We appreciate your persistence and hard work, keep going !! 👏 <br/><br/>';
        htmlBodyEmployee += 'Thanks & Regards,<br/><br/>';
        htmlBodyEmployee += '<Sender Name>';
        htmlBodyEmployee += '<h2 style="color: #3da8ef;">Metacube Software Pvt. Ltd.</h2>';
        htmlBodyEmployee += 'SP-6, Phase IV, EPIP Sitapura, Jaipur, Rajasthan';
        
        
        // Set the HTML body for the email employee
        emailToEmployee.setHtmlBody(htmlBodyEmployee);
        
        // Send the email to the employee who redeemed reward
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{emailToEmployee});
        
    } 
    
    
}