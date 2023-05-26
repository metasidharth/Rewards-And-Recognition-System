public class EmployeeUnderBadge {
    @AuraEnabled(Cacheable=true) 
    public static List<Employee_Badge__c> getEmployee(String badgeId){
        List <Employee_badge__c> badgeHoldersList=new List<Employee_Badge__c> ();
        SelectorForEmployeeBadge badgeHolderSelector=new SelectorForEmployeeBadge();
        badgeHoldersList=badgeHolderSelector.getBadgeHolder(badgeId);
        return badgeHoldersList;
        
        /*
        return [select Name, Category__r.Name ,Employee__r.Name,Employee__r.Employee_Id__c ,Total_Points__c,Assigned_Badge__r.Name from Employee_Badge__c
                where Assigned_Badge__c= :badgeId order by Total_Points__c DESC   ];
        */
    }
    
    @AuraEnabled(Cacheable=true)
    public static List<Badge_Configuration__c> getBadge(String currentBadgeId){
        
        SelectorForBadgeConfiguration BadgeConfigSelector=new SelectorForBadgeConfiguration();
        List<Badge_Configuration__c> badgeList= BadgeConfigSelector.getBadges(currentBadgeId);
        return badgeList;
        /*
        return [select Name ,Image__c, Category__r.Name from Badge_Configuration__c where Id=:currentBadgeId ];
        */
    }
    
    public static String getCurrentEmployee(){    
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
    
    
    @AuraEnabled(Cacheable=true) 
    public static List<Employee_Reward__c> getRewardHistory(){
       String employeeId=getCurrentEmployee();
        System.debug('The Employee Id is '+employeeId);
        /*
        List<Employee_Reward__c> rewardHistory=  [select  Name,Employee__r.Name,Date__c ,Earned_Reward__r.Name,Earned_Reward__r.Reward_Image__c,Points_Redeemed__c,Status__c from Employee_Reward__c where Employee__c =:employeeId Order By Date__c DESC];
		*/
        SelectorForEmployeeReward employeeRewardSelector=new SelectorForEmployeeReward();
        List<Employee_Reward__c> rewardHistory= employeeRewardSelector.getEmployeeRewardHistory(employeeId);
        System.debug('the reward history is '+ rewardHistory);
        return  rewardHistory;
        
    }
    
    
}