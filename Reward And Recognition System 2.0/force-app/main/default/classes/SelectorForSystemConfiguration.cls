public class SelectorForSystemConfiguration  {
 public string objectName='System_Configuration__c';
    public String fieldName='Name,Category__r.Name,Sub_Category__r.Name,System__r.Name,Points__c';
    //public Schema.SObjectType getSObjectType(){
      //  return 	System_Configuration__c.SObjectType;    
   // }
    /*
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            System_Configuration__c.Name,
            System_Configuration__c.Category__r.Name, 
            System_Configuration__c.Sub_Category__r.Name,
            System_Configuration__c.System__r.Name,
            System_Configuration__c.Points__c
     		};
    }
*/
    
    public List<System_Configuration__c> getSystemConfiguration(){
        
        String query=String.format('select {0} from {1}',
                                   new List<String> {fieldName,objectName});
        
        return  Database.query(query);
    }
}