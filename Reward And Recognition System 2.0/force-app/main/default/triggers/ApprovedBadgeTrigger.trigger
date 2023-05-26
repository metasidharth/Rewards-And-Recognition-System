trigger ApprovedBadgeTrigger on Employee_Badge__c (before Update) {

    List<Employee_badge__c> employeeBadgeList= new List<Employee_badge__c>();
    for(Employee_Badge__c empBadge:trigger.new){
        if(empBadge.Status__c=='Approved'){
            empBadge.Assigned_Badge__c=empBadge.Recommended_Badge__c;
            //empBadge.Recommended_Badge__c = NULL;
            employeeBadgeList.add(empBadge);
        }
        
    }
    

}