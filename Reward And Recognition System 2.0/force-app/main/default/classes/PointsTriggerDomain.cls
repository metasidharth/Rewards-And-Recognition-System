public class PointsTriggerDomain extends fflib_SObjectDomain {
    List<System_Configuration__c> configList = [SELECT Name, Points__c FROM System_Configuration__c];
    List<Feedback__c> newFeedbackList = new List<Feedback__c>();
    
    public PointsTriggerDomain(List<Feedback__c> sObjectList) {
        super(sObjectList);  
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new PointsTriggerDomain(sObjectList);
        }
    }
    public override void onBeforeInsert(){
        for (Feedback__c rf : (List<Feedback__c>)Trigger.new) {
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
    
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords){
                for (Feedback__c rf : (List<Feedback__c>)Trigger.new) {
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
}