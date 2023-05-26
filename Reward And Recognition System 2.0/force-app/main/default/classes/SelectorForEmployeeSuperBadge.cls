public class SelectorForEmployeeSuperBadge {
    
    public string objectName='Employee_Super_Badge__c';
    public String fieldName='Employee__r.Name,Category__r.Name, Super_Badge_Configuration__r.Name,Super_Badge_Configuration__r.Super_Badge_Image__c';
    
    public List<Employee_Super_Badge__c> getEmployeeSuperBadge(String EmployeeId){   
        String query=String.format('select {0} from {1} where Employee__c= :EmployeeId',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
}