public class SelectorForStatusTracking {
    public string objectName='Status_Tracking__c';
    public String fieldName='Status__c,Processed_Date__c,Employee_Reward__r.Earned_Reward__r.Name';
    
    public List<Status_Tracking__c> getStatus(String rewardId){   
        String query=String.format('select {0} from {1} where Employee_reward__c =:rewardId order by Processed_Date__c DESC',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
}