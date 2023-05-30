public class SuperBadgeTriggerDomain  extends fflib_SObjectDomain {
    Map<String,Super_Badge_Configuration__c> superBadgeMap= new Map<String,Super_Badge_Configuration__c>(); 
    List<Employee_Super_Badge__c> newList = new List<Employee_Super_Badge__c>();    
    
    public SuperBadgeTriggerDomain(List<Employee_Badge__c> sObjectList) {
        super(sObjectList);
        // Initialize superBadgeMap when constructing the domain
        for(Super_Badge_Configuration__c superBadge:[Select Name,Super_Badge_Image__c,Category__c,Required_Badge__c from Super_Badge_Configuration__c]){
            superBadgeMap.put(superBadge.Required_Badge__c,superBadge);
        } 
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new SuperBadgeTriggerDomain(sObjectList);
        }
    }
    
    public override void onAfterUpdate(Map<Id,SObject> existingRecords){
        for(Employee_Badge__c empBadge:(List<Employee_Badge__c>)Trigger.new){        
            Employee_Badge__c oldRecord=(Employee_Badge__c)existingRecords.get(empBadge.Id);
            if(empBadge.Assigned_Badge__c != NULL && empBadge.Assigned_Badge__c != oldRecord.Assigned_Badge__c){
                if(superBadgeMap.get(empBadge.Assigned_Badge__c)!=Null){
                    Employee_Super_Badge__c superBadge = new Employee_Super_Badge__c();
                    superBadge.Employee__c = empBadge.Employee__c;
                    superBadge.Category__c = empBadge.Category__c;
                    superBadge.Super_Badge_Configuration__c = superBadgeMap.get(empBadge.Assigned_Badge__c).Id;
                    newList.add(superBadge);
                }
            }       
        }
        if(newList!=null){
            insert newList;
        }
    }
}