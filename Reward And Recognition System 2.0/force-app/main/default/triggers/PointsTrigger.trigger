trigger PointsTrigger on Feedback__c (before insert, before update) {
    List<System_Configuration__c> configList = [SELECT Name, Points__c FROM System_Configuration__c];

    for (Feedback__c rf : Trigger.new) {
        if (rf.System_Configuration__c == null) {
            rf.addError('System Configuration is required.');
        } else {
            for (System_Configuration__c configuration : configList) {
                if (rf.System_Configuration__c == configuration.Id) {
                    try {
                        rf.Points__c = (Decimal)rf.Rating__c * configuration.Points__c;
                    } catch (Exception ex) {
                        rf.addError('For this object, the system configuration is not available: ' + ex.getMessage());
                    }
                }
            }
        }
    }
}