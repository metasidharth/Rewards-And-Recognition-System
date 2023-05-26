trigger SuperBadgeTrigger on Employee_Badge__c (after update) {
	
    
    Map<String,Super_Badge_Configuration__c> newMap= new Map<String,Super_Badge_Configuration__c>();
    
    for(Super_Badge_Configuration__c superBadge:[Select Name,Super_Badge_Image__c,Category__c,Required_Badge__c from Super_Badge_Configuration__c]){
        newMap.put(superBadge.Required_Badge__c,superBadge);
    }
    
	List<Employee_Super_Badge__c> newList = new List<Employee_Super_Badge__c>();    
    
    for(Employee_Badge__c empBadge:Trigger.new){
        
        if(newMap.get(empBadge.Assigned_Badge__c) != NULL && Trigger.newMap.get(empBadge.Id).Assigned_Badge__c != Trigger.oldMap.get(empBadge.Id).Assigned_Badge__c){
            Employee_Super_Badge__c superBadge = new Employee_Super_Badge__c();
            superBadge.Employee__c = empBadge.Employee__c;
            superBadge.Category__c = empBadge.Category__c;
            superBadge.Super_Badge_Configuration__c = newMap.get(empBadge.Assigned_Badge__c).Id;
            newList.add(superBadge);
        }
        
    }
    insert newList;
    
}