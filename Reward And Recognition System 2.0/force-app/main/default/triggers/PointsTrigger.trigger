trigger PointsTrigger on Feedback__c (before insert, before update) {
     fflib_SObjectDomain.triggerHandler(PointsTriggerDomain.class);     
}

/*
List<System_Configuration__c> configList = [SELECT Name, Points__c FROM System_Configuration__c];
    List<Feedback__c> newFeedbackList = new List<Feedback__c>();

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
    
*/