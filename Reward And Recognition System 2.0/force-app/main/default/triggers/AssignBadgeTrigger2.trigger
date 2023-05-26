trigger AssignBadgeTrigger2 on Feedback__c (after  insert, after Update) {
    List<AggregateResult> feedbackList= new List<AggregateResult>();
  List<Id> employeeIdList=new List<Id>();
    List<Id> categoryList=new List<Id>();
    
    Map<Id,System_Configuration__c> sysConfigMap = new Map<Id,System_Configuration__c>();
    for(System_Configuration__c sys: [select Id,Category__c,Sub_Category__c,System__c from System_Configuration__c]){
	        sysConfigMap.put(sys.Id,Sys);
    }
       
    for(Feedback__c newFeedback:Trigger.new){
        employeeIdList.add(newFeedback.Employee__c);
        
        categoryList.add(sysConfigMap.get(newFeedback.System_Configuration__c).Category__c);
        
    }
    system.debug('The category list is '+ categoryList);
    
    feedbackList = [SELECT Employee__c, System_Configuration__r.Category__c, SUM(Points__c)
                                          FROM FeedBack__c WHERE Employee__c IN :employeeIdList AND System_Configuration__r.Category__c IN :categoryList
                                          GROUP BY System_Configuration__r.Category__c, Employee__c];
    System.debug('The new List '+ Trigger.new);
    
    
    
    List<Badge_Configuration__c> badgeConfigList=[select name ,Category__c ,Required_Points__c,Title__c from Badge_Configuration__c order by Required_Points__c  ];
    List<Employee_Badge__c> employeeBadgeList=[select Employee__c,Status__c, Category__c, Total_Points__c ,Recommended_Badge__c,Assigned_Badge__c from Employee_Badge__c where Employee__c In :EmployeeIdList ];
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
            
            Badge_Configuration__c highestEligibleBadge = null; 
            Boolean isNewEligibleBadge = false;
            for(Badge_Configuration__c bg : badgeConfigList){
                if(existingBadge.Category__c == bg.Category__c && existingBadge.Total_Points__c >= bg.Required_Points__c){
                    if(highestEligibleBadge == null || bg.Required_Points__c > highestEligibleBadge.Required_Points__c){
                        highestEligibleBadge = bg;
                        isNewEligibleBadge=true;
                    }
                }
            }
            
            if(isNewEligibleBadge == true && existingBadge.Assigned_Badge__c != highestEligibleBadge.Id){                    
                existingBadge.Status__c = 'Pending';
                existingBadge.Recommended_Badge__c = highestEligibleBadge.Id;  
                
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
    
    
    
    //for Inserting and updating the Monetization points in employee 
   // List<AggregateResult> pointsList = new List<AggregateResult>();
   // pointsList=[SELECT Employee__c , SUM(Points__c) FROM FeedBack__c WHERE Employee__c IN : employeeIdList GROUP BY Employee__c];
       
   // Map<Id,Employee__c> employeeMap=new Map<Id,Employee__c>();
   
  //  for(Employee__c emp:[Select Name,Employee_Id__c,Monetization_Points__c from Employee__c]){
       // employeeMap.put(emp.Id, emp);       
  //  }
    
    //List<Employee__c> updateEmployees = new List<Employee__c>(); 
    //for(AggregateResult arg : pointsList){
      //  Employee__c emp = new Employee__c();
       // emp = employeeMap.get(String.valueOf(arg.get('Employee__c')));
       // System.debug('Employee Id is ' + emp);
       // emp.Monetization_Points__c = (Decimal)arg.get('expr0');
       // updateEmployees.add(emp);
   // }
  //  update updateEmployees;
 
}