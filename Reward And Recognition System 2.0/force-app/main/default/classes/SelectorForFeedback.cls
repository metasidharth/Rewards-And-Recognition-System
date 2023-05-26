public class SelectorForFeedback {
    public  String objectName = 'Feedback__c';
    public  String fieldName = 'Employee__r.Name, Employee__r.Employee_Id__c,Quarter__r.Name, Points__c, System_Configuration__r.Category__r.Name, System_Configuration__r.Sub_Category__r.Name,Rating__c';

    public List<Feedback__c> getFeedback() {
        String query = String.format('SELECT {0} FROM {1}', new List<String> {fieldName, objectName});
        return Database.query(query);
    }

    public List<Feedback__c> getFeedback(String categoryValue, String subCategoryValue, String quarterValue) {
        String query = String.format('SELECT {0} FROM {1} WHERE System_Configuration__r.Category__r.Name LIKE :categoryValue AND System_Configuration__r.Sub_Category__r.Name LIKE :subCategoryValue AND Quarter__r.Name LIKE :quarterValue ORDER BY Points__c DESC LIMIT 10',
                                     new List<String> {fieldName, objectName});
        
        return Database.query(query);
    }
}