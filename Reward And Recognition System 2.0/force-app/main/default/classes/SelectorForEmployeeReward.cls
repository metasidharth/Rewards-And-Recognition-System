public class SelectorForEmployeeReward {
public string objectName='Employee_Reward__c ';
    public String fieldName='Name,Employee__r.Name,Date__c ,Earned_Reward__c,Earned_Reward__r.Name,Earned_Reward__r.Reward_Image__c,Points_Redeemed__c,Status__c';
     
    public List<Employee_Reward__c > getEmployeeRewardHistory(String employeeId){   
        String query=String.format('select {0} from {1} where Employee__c =:employeeId Order By Date__c DESC',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
    
    public List<Employee_Reward__c> getEmployeeReward(String rewardId){
        String query=String.format('select {0} from {1} WHERE Id =: rewardId',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
}