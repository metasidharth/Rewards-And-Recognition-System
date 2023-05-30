public class FetchEmployeeBadge {

    @AuraEnabled(cacheable=true)
    public static List<Employee_Badge__c> fetchEmpBadge(Id employeeId){
        /*
        List<Employee_Badge__c> badges =[select Employee__r.Name,Category__r.Name,Assigned_Badge__r.Title__c,Assigned_Badge__r.Image__c from Employee_Badge__c where Employee__c=:EmployeeId];
       */
        
        SelectorforEmployeeBadge EmployeeBadgeSelector= new SelectorforEmployeeBadge();
        List<Employee_Badge__c> badges=EmployeeBadgeSelector.getEmployeeBadge(employeeId);
        List<Employee_Badge__c> filterList= new List<Employee_Badge__c>();
        for(Employee_Badge__c bg:badges){
            if(bg.Assigned_Badge__c!=Null){
                filterList.add(bg);
            }
        }
        return filterList;    
    }
    
   @AuraEnabled(cacheable=true)
    public static List<AggregateResult> fetchEmpInBadge(){
         return [SELECT Assigned_Badge__c,COUNT(Employee__c) employeeCount FROM Employee_Badge__c GROUP BY Assigned_Badge__c];
    }    

    @AuraEnabled(cacheable=true)
    public static List<Badge_Configuration__c> getBadges(){  
        SelectorForBadgeConfiguration badgeSelector=new SelectorForBadgeConfiguration();
        List<Badge_Configuration__c> badgeList=badgeSelector.getBadges();
        return badgeList;
        
        /*
        return [Select Name,Category__r.Name,Image__c from Badge_Configuration__c];
       */
    }

    @AuraEnabled(cacheable=true)
    public static List<Employee_Super_Badge__c> fetchEmpSuperBadge(Id employeeId){
        try {
            /*
            List<Employee_Super_Badge__c> superBadges = [Select Employee__r.Name,Category__r.Name, 
                                                         Super_Badge_Configuration__r.Name,
                                                         Super_Badge_Configuration__r.Super_Badge_Image__c
                                                         from Employee_Super_Badge__c 
                                                         where Employee__c=:EmployeeId];
            */
            SelectorForEmployeeSuperBadge employeeSuperBadgeSelector= new SelectorForEmployeeSuperBadge();
            List<Employee_Super_Badge__c> superBadges=employeeSuperBadgeSelector.getEmployeeSuperBadge(employeeId);
            return superBadges;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}