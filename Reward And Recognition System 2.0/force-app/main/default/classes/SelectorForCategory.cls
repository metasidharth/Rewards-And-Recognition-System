public class SelectorForCategory extends fflib_SObjectSelector{

    public Schema.SObjectType getSObjectType(){
        return 	Category__c.SObjectType;    
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Category__c.Id,
            Category__c.Name};
    }
    
    public List<Category__c> getCategory(){
        
        String query=String.format('select {0} from {1}',
                                   new List<String> {getFieldListString(),getSObjectName()});
        
        return (List<Category__c>) Database.query(query);
    }
}