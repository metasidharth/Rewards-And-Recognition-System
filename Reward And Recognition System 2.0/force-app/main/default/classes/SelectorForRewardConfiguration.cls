public class SelectorForRewardConfiguration {
    public string objectName='Reward_Configuration__c ';
    public String fieldName='Name ,Reward_Image__c,Required_Reward_Points__c,Reward_Type__c';
    
    public List<Reward_Configuration__c> getRewardConfig(){   
        String query=String.format('select {0} from {1} ',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
}