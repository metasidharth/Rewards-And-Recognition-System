public class SelectorForSubCategory extends fflib_SObjectSelector {

     public Schema.SObjectType getSObjectType(){
        return 	Sub_Category__c.SObjectType;    
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Sub_Category__c.Name};
    }
    
    public List<Sub_Category__c> getSubCategory(String categoryValue){
        String query=String.format('select {0} from {1} where Category__r.name like: categoryValue',
                                   new List<String> {getFieldListString(),getSObjectName()});   
        return (List<Sub_Category__c>) Database.query(query);
    }
    
       public List<Sub_Category__c> getSubCategoryForRRAPI(){
        String query=String.format('select {0} from {1}',
                                   new List<String> {getFieldListString(),getSObjectName()}); 
        return (List<Sub_Category__c>) Database.query(query);
    }
}