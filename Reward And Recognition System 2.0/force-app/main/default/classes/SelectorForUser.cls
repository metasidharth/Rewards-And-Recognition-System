public class SelectorForUser {
    public string objectName='User';
    public String fieldName=' email,contactId,Contact.Name';
    
    public List<User> getUser(String userId){   
        String query=String.format('select {0} from {1} where Id= :userId',
                                   new List<String> {fieldName,objectName});
        return  Database.query(query);
    }
}