public class Rewards {
    
    @AuraEnabled(Cacheable=true)
    public static List<Reward_Configuration__c>getRewardConfig(){
        SelectorForRewardConfiguration rewardConfigSelector=new SelectorForRewardConfiguration();
        List<Reward_Configuration__c> rewardConfigList=rewardConfigSelector.getRewardConfig();
        return rewardConfigList;
        /*
        return[select Name ,Reward_Image__c,Required_Reward_Points__c,Reward_Type__c from Reward_Configuration__c];
       */
    }
    
    @AuraEnabled
    public static String setEmployeeReward(Id employeeId,Reward_Configuration__c reward){
        // ToastClass toastObj=new ToastClass();
        System.debug('this is employee Id'+ employeeId);
        System.debug('this is reward object'+ reward);
        Decimal requiredPoints=reward.Required_Reward_Points__c;
        // SelectorForEmployee employeeSelector=new SelectorForEmployee();
        
        SelectorForEmployee employeeSelector=new SelectorForEmployee();
        Employee__c employee=employeeSelector.getEmployee(employeeId).get(0);
        
        /*
        Employee__c  employee=[select name,Email__c,Designation__c ,Employee_Id__c,Roll_Up_Total_Points__c,Monetization_Points__c from Employee__c where id=: employeeId].get(0);
        */
        
        Employee_Reward__c newEmployeeReward=new Employee_Reward__c();
        if( employee.Monetization_Points__c-requiredPoints>=0){
            
            //newEmployeeReward.Name=employee.name+' reward';
            newEmployeeReward.Date__c=Date.today();
            newEmployeeReward.Points_Redeemed__c=requiredPoints;
            newEmployeeReward.Employee__c=employee.Id;
            newEmployeeReward.Earned_Reward__c=reward.Id;
            System.debug('the new employeeReward is'+newEmployeeReward);
            insert newEmployeeReward;
            try {
                 sendEmail(employee,reward);
            } catch (Exception e) {
                if (e instanceof System.EmailException) {
                    
                    System.debug('Email exception occurred: ' + e.getMessage());
                    
                } else {
                    // handle other exceptions here
                    System.debug('Other exception occurred: ' + e.getMessage());
                    
                }
            }
            
            
            
            String message='The reward '+ reward.Name+' is redeem successfully';
            return message;
        }
        else{
            String message=  'You cannot redeem this reward the your points are less';
            return message;         
        }
        
    }
    
    @AuraEnabled(Cacheable=true)
    public static String getEmployee(){
        /*
         User currentUser = [SELECT email,contactId,Contact.Name FROM User WHERE Id = :UserInfo.getUserId()].get(0); 
        */
        
        SelectorForUser userSelector=new SelectorForUser();
        User currentUser=userSelector.getUser(UserInfo.getUserId()).get(0);
        
        System.debug('the current user is '+currentUser);
        /*
        Contact currentContact=[SELECT Employee__c from Contact where Id=:currentUser.ContactId].get(0);
       */
        SelectorForContact contactSelector= new SelectorForContact();
        Contact currentContact= contactSelector.getContact((currentUser.ContactId)).get(0);
        System.debug('the current contact is '+currentContact);
        System.debug('the Employee Id is '+currentContact.Employee__c );
        return currentContact.Employee__c  ;
    }
    
    
    @AuraEnabled
    public static List<Employee__c> empDetails(String empId){
        List<Employee__c> empList =  new List<Employee__c>();
        SelectorForEmployee EmployeeSelector=new SelectorForEmployee();
        empList=EmployeeSelector.getEmployee(empId); 
        
        /*
        emplist= [Select Name,Email__c,Employee_Id__c,Monetization_Points__c,Roll_Up_Employee_Reward__c,Roll_Up_Total_Points__c
        from Employee__c where Id=: empId];
        */       
        System.debug('EmpId is '+ empId);
        System.debug('empList is ' + empList);
        return emplist; 
    }
    
    
    public static void sendEmail(Employee__c employee,Reward_Configuration__c reward){
        List<Employee__c> hrList=[select name , Email__c  from Employee__c WHERE Designation__c like 'HR'];
        List<String> emailListString = new List<String>();
        
        for(Employee__c emp:hrList){
            if(emp.Email__c != NULL) {
                emailListString.add(String.valueOf(emp.Email__c));
            }
        }
        
        // Generate the email body for Hr  using an email template
        Messaging.SingleEmailMessage emailToHR = new Messaging.SingleEmailMessage();
        emailToHR.setTemplateId('00X2w000000WqF9');
        emailToHR.setToAddresses(emailListString);
        emailToHR.setSubject( 'Regarding Employee Reward ');
        //  emailToHR.setTargetObjectId(UserInfo.getUserId());
        emailToHR.setSaveAsActivity(false);
        emailToHR.setPlainTextBody('');
        
        // Generate the HTML email body
        String htmlBodyHR = 'Dear HR,<br/><br/>';        
        htmlBodyHR += employee.Name+' ('+employee.Employee_Id__c+ ') '+' has redeemed  ' +Reward.Name + ' <br/><br/>';
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
        emailToEmployee.setTemplateId('00X2w000000WqF9');
        emailToEmployee.setToAddresses(EmployeeEmail);
        emailToEmployee.setSubject( 'Regarding Your Redeemed Reward ');
        //  emailToEmployee.setTargetObjectId(UserInfo.getUserId());
        emailToEmployee.setSaveAsActivity(false);
        emailToEmployee.setPlainTextBody('');
        
        // Generate the HTML email body
        String htmlBodyEmployee = 'Dear Employee,<br/><br/>';        
        htmlBodyEmployee += employee.Name+' ('+employee.Employee_Id__c+ ') '+' you have redeemed your reward ' +Reward.Name  +'. <br/><br/>';
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
    
    
    @AuraEnabled(Cacheable=true)
    public static List<Employee_Reward__c> progressBarDetail(Id rewardId){
        return [select Employee__r.name,Earned_Reward__c,Status__c from Employee_Reward__c where Id =: rewardId];
    }
    
    @AuraEnabled(Cacheable=true)
    public static List<Status_Tracking__c> getStatusHistory(Id rewardId){
        /*
        return [Select Status__c,Processed_Date__c,Employee_Reward__r.Earned_Reward__r.Name from Status_Tracking__c where Employee_reward__c =:rewardId order by Processed_Date__c DESC];
		*/
        SelectorForStatusTracking statusSelector= new SelectorForStatusTracking();
        List<Status_Tracking__c> rewardStatusList=statusSelector.getStatus(rewardId);
        return rewardStatusList;
    }
    
    
    
    
    
}