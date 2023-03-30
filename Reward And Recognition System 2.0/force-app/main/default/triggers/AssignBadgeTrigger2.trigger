trigger AssignBadgeTrigger2 on Feedback__c (after  insert, after Update) {
    List<AggregateResult> feedbackList= new List<AggregateResult>();
  List<Id> EmployeeIdList=new List<Id>();
    for(Feedback__c newFeedback:Trigger.new){
        EmployeeIdList.add(newFeedback.Employee__c);
    }
    
    feedbackList = [SELECT Employee__c, System_Configuration__r.Category__c, SUM(Points__c)
                                          FROM FeedBack__c WHERE Employee__c IN :EmployeeIdList
                                          GROUP BY System_Configuration__r.Category__c, Employee__c];
    System.debug('The new List '+ Trigger.new);
    
    
    List<Badge_Configuration__c> badgeConfigList=[select name ,Category__c ,Required_Points__c,Title__c from Badge_Configuration__c];
    List<Employee_Badge__c> employeeBadgeList=[select Employee__c, Category__c, Total_Points__c ,Recommended_Badge__c from Employee_Badge__c ];
    List<Employee_Badge__c> EmployeeBadgeToUpdate= new List<Employee_Badge__c>();
    
    // Loop through feedback results to update or create Employee Badge records
    for(AggregateResult result:feedbackList){
        String employee=(String)result.get('Employee__c');
        String category=(String)result.get('Category__c');
        Double totalPoints=(Double)result.get('expr0');
        
        // Check if an existing Employee Badge record exists for the employee and category
        Employee_Badge__c existingBadge = null;
        for(Employee_Badge__c badge:employeeBadgeList){
            if(badge.Employee__c==employee && badge.Category__c==category){
                existingBadge = badge;
                break;
            }
        }
        
        // If an existing Employee Badge record exists, update it
        if(existingBadge != null){
            existingBadge.Total_Points__c=totalPoints;
            
            for(Badge_Configuration__c bg:badgeConfigList){
                if(existingBadge.Category__c==bg.Category__c && existingBadge.Total_Points__c>=bg.Required_Points__c){
                    existingBadge.Status__c='Pending';
                    existingBadge.Recommended_Badge__c=bg.Id;
                    System.debug('the Existing EmployeeBadge  is '+existingBadge );
                }
            }
            EmployeeBadgeToUpdate.add(existingBadge);
        }
        
        // If no existing Employee Badge record exists, create a new one
        else{
            Employee_Badge__c empBadge=new Employee_Badge__c();
            empBadge.Employee__c=employee;
            empBadge.Category__c=category;
            empBadge.Total_Points__c=totalPoints;
            for(Badge_Configuration__c  badgeConfig:badgeConfigList ){
                if(empBadge.Category__c==badgeConfig.Category__c && empBadge.Total_Points__c>=badgeConfig.Required_Points__c){
                    empBadge.Status__c='Pending';
                    empBadge.Recommended_Badge__c=badgeConfig.Id;
                }
            }
            EmployeeBadgeToUpdate.add(empBadge);
        }
    }  
    
    // Upsert all Employee Badge records
    System.debug('the lis is '+EmployeeBadgeToUpdate);
    Upsert EmployeeBadgeToUpdate;
}