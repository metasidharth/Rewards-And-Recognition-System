public class SelectorForEmployeeBadge {
    public string objectName='Employee_Badge__c ';
    public String fieldName='Name,Employee__r.Name,Category__r.Name,Assigned_Badge__r.Title__c,Assigned_Badge__r.Image__c,Employee__r.Employee_Id__c,Total_Points__c,Assigned_Badge__r.Name';
    
    public List<Employee_Badge__c> getEmployeeBadge(String EmployeeId){   
        String query=String.format('select {0} from {1} where Employee__c= :EmployeeId',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
    
    public List<Employee_Badge__c> getBadgeHolder(String badgeId){
                String query=String.format('select {0} from {1} where Assigned_Badge__c= :badgeId order by Total_Points__c DESC ',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
    
    public List<Employee_Badge__c> getEmployeeBadge(){
         String query=String.format('select {0} from {1} ',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
    
}