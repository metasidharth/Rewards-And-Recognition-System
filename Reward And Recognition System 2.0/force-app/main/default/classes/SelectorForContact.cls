public class SelectorForContact {
      public string objectName='Contact ';
    public String fieldName='Employee__c';
    
    
    public List<Contact> getContact(String ContactId){   
        String query=String.format('select {0} from {1} where Id= :ContactId',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
}