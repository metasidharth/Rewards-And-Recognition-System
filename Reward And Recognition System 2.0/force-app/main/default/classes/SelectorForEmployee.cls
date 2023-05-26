public class SelectorForEmployee {
    public string objectName='Employee__c ';
    public String fieldName='Name,Email__c,Designation__c ,Employee_Id__c,Roll_Up_Total_Points__c,Monetization_Points__c,Roll_Up_Employee_Reward__c';
    
    public List<Employee__c> getEmployee(String EmployeeId){   
            String query=String.format('select {0} from {1} where id= :EmployeeId',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
    
      public List<Employee__c> getEmployee(){   
            String query=String.format('select {0} from {1} ',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
    
}