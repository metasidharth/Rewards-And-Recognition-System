public class SelectorForSystemRRAPI extends fflib_SObjectSelector{

    public Schema.SObjectType getSObjectType(){
        return 	System__c.SObjectType;    
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            System__c.Name,
            System__c.Approver_Email__c
     		};
    }
    
    public List<System__c> getSystem(){
        
        String query=String.format('select {0} from {1}',
                                   new List<String> {getFieldListString(),getSObjectName()});
        
        return (List<System__c>) Database.query(query);
    }
}