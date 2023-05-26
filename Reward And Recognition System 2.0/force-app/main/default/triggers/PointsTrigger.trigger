trigger PointsTrigger on Feedback__c (before insert, before update) {
    List<System_Configuration__c> configList = [SELECT Name, Points__c FROM System_Configuration__c];
	List<Feedback__c> newFeedbackList = new List<Feedback__c>();
    
        for(Integer j=0;j<Trigger.new.size()-1;j++){
            if(Trigger.new.size() > 1){
                for(Integer i=j+1;i<Trigger.new.size();i++){
            		if(Trigger.new[j].Employee__c == Trigger.new[i].Employee__c && Trigger.new[j].System_Configuration__c == Trigger.new[i].System_Configuration__c
                       && Trigger.new[j].Quarter__c == Trigger.new[i].Quarter__c){
                           
                           Trigger.new[j].Rating__c += Trigger.new[i].Rating__c; 
                           newFeedbackList.add(Trigger.new[i]);
                       }
        	     }
            }
        	
        }
    
    for (Feedback__c rf : Trigger.new) {
        if (rf.System_Configuration__c == null) {
            rf.addError('System Configuration is required.' + rf.System_Configuration__r.Name);
        }
        else {
            for (System_Configuration__c configuration : configList) {
                if (rf.System_Configuration__c == configuration.Id) {
                    try {
                        Decimal rating = (Decimal)rf.Rating__c;
                        Decimal points = configuration.Points__c;
                        if (rating != null && points != null) {
                            rf.Points__c = rating * points;
                        } else {
                            rf.addError('System Configuration not found.' + configuration.Name );
                        }
                    } catch (Exception ex) {
                        rf.addError('For this object, the system configuration is not available: ' + ex.getMessage());
                    }
                }
            }
        }
    }
    
  
    
}