public class ApprovedBadgeDomain extends fflib_SObjectDomain {
    
    public ApprovedBadgeDomain(List<Employee_Badge__c> sObjectList) {
        super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new ApprovedBadgeDomain(sObjectList);
        }
    }
       
    // Logical code for Trigger 
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {      
        List<Employee_badge__c> employeeBadgeList= new List<Employee_badge__c>();
        List<Employee_badge__c> enl = (List<Employee_badge__c>)trigger.new;
        for(Employee_Badge__c empBadge:enl){
            if(empBadge.Status__c=='Approved'){
                empBadge.Assigned_Badge__c=empBadge.Recommended_Badge__c;
                //empBadge.Recommended_Badge__c = NULL;
                employeeBadgeList.add(empBadge);
            }
            
        }
    }
    
}