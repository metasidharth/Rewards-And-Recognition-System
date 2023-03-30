public class FetchEmployeeBadge {

    @AuraEnabled(cacheable=true)
    public static List<Employee_Badge__c> fetchEmpBadge(Id employeeId){
        
        List<Employee_Badge__c> badges =[select Employee__r.Name,Category__r.Name,Assigned_Badge__r.Title__c,Assigned_Badge__r.Image__c from Employee_Badge__c where Employee__c=:EmployeeId];
        return badges;
        
    }
}