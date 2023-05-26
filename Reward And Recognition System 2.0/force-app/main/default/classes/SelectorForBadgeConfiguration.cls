public class SelectorForBadgeConfiguration {
    
    public string objectName='Badge_Configuration__c';
    public String fieldName='Name,Category__r.Name,Image__c';
    
    public List<Badge_Configuration__c> getBadges(){   
        String query=String.format('select {0} from {1}',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
    
    public List<Badge_Configuration__c> getBadges(String currentBadgeId){
         String query=String.format('select {0} from {1}  where Id=:currentBadgeId',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
    
    
}