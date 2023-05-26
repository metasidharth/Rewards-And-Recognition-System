public class SelectorForEmployeeAPI extends fflib_SObjectSelector {

     public Schema.SObjectType getSObjectType(){
        return 	Employee__c.SObjectType;    
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Employee__c.Name,
            Employee__c.First_Name__c,
            Employee__c.Last_Name__c,
            Employee__c.Email__c,
            Employee__c.Employee_Id__c
        };
    }
    
    public List<Employee__c> getEmployee(){
        
        String query=String.format('select {0} from {1}',
                                   new List<String> {getFieldListString(),getSObjectName()});
        
        return (List<Employee__c>) Database.query(query);
    }
}