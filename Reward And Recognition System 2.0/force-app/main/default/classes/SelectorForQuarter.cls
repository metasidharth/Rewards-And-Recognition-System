public class SelectorForQuarter extends fflib_SObjectSelector {
   
    public Schema.SObjectType getSObjectType(){
        return Quarter__c.SObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Quarter__c.Name     
                };
     }
    
    public List<Quarter__c> getQuarter(){
        String query=String.format('select {0} from {1} ',new List<String>{getFieldListString(),getSObjectName()});
        return (List<Quarter__c>) Database.query(query);
    } 

}