public class SelectorForLeaderboard extends fflib_SObjectSelector{
  
    public Schema.SObjectType getSObjectType(){
        return  Feedback__c.SObjectType;
    }
        public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            //Feedback__c.Employee__c,
            Feedback__c.Employee__r.Name,
            Feedback__c.Points__c,
            Feedback__c.Description__c,
            Feedback__c.System_Configuration__r.Category__c,
            Feedback__c.System_Configuration__r.Sub_Category__c,
            Feedback__c.quarter__r.Name
            };
    }
    
    public List<Feedback__c> getLeaderboard(String categoryValue , String subCategoryValue, String quarterValue){
        
        String query=String.format('select {0} from {1} where System_Configuration__r.Category__c =:categoryValue and System_Configuration__r.Sub_Category__c =:subCategoryValue and Quarter__r.Name like :quarterValue order by Points__c DESC limit 10'
                                   ,new List<String>{getFieldListString(),getSObjectName()});
        return (List<Feedback__c>) Database.query(query);
    }
    
    
}