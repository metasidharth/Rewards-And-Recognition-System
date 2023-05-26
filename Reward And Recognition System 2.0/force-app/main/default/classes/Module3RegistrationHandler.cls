/**
  Registration Handler for External Identity Trail
**/
global class Module3RegistrationHandler implements Auth.RegistrationHandler{
    
    private static final String ORG_SUFFIX = '.sso.badge.org';
    private static final String DEFAULT_ACCOUNTNAME = 'Metacube';
    private static final String EXTERNAL_USER_PROFILE = 'Employee Community Login User';
    private static final String INTERNAL_USER_PROFILE = 'System Administrator';  
    private static final String TZSID = [SELECT timezonesidkey from User where profile.name = 'System Administrator' LIMIT 1].timezonesidkey;
    
/**
 * Let anyone register as long as the required fields are supplied
 * 
 * We require email, lastName, firstName
 * 
 * @data - the user's info from the Auth Provider
 **/ 
global boolean canCreateUser(Auth.UserData data) {
    System.debug('canCreateUser was called for ' + (data != null ? data.email : 'null'));
    Boolean retVal = (data != null 
            && data.email != null
            && data.lastName != null
            && data.firstName != null);
    
    System.debug('data.username='+data.username);
    System.debug('data.email='+data.email);
    System.debug('data.lastName='+data.lastName);
    System.debug('data.firstName='+data.firstName);
    
    return retVal;
}

/**
 * Create the User - A required method to implement the Handler Interface
 * 
 * @param portalId  - Id of the Community
 * @param data - Auth Provider user data describing the User to create
 * 
 * @return User that has been initialized
**/ 
global User createUser(Id portalId, Auth.UserData data){
    if(!canCreateUser(data)) {
        // Returning null signals the auth framework we can't create the user
        return null;
    }
    
    // Is this a Community Context?
    if(data.attributeMap.containsKey('sfdc_networkid')) {
        System.debug('Registering Community user: ' + data.email);
        Id contactId;

        // Checking to see if the email address is already used by another Contact
        // If so, use that contact and user
        List<Contact> existingContacts = [select id, email from Contact where email =: data.email];
        System.debug('the List of Existing contacts are from hander '+existingContacts);
        // code modify for update the contact employee field with the employee by rr team 
        List<Employee__c> matchingEmployee=[select id,name from Employee__c where Email__c=:data.email];
        System.debug('the List of Matching Employee Email is from handler'+matchingEmployee);
        if (existingContacts.size() > 0){
            // Use the first Contact with matching email
            Contact existingContact = existingContacts[0];
            System.debug('the Existing contacts are from hander '+existingContact);
            System.debug('the  Matching Employee Email is from handler'+matchingEmployee.get(0));
            existingContact.Employee__c=matchingEmployee.get(0).Id;
            update existingContact;
            contactId = existingContact.Id;
            List<User> existingUsers = [select id from User where ContactId =: contactId];
            if (existingUsers.size() == 1){
                // Use this User instead of creating a new one
                // The Registration Handler system will assoicate the Auth Provider
                // with this user
                return existingUsers[0];
            }
        } else {
            // No matching Contacts found
            // So we create one
            // To keep things modular, we're creating the Contact in a separate method
            contactId = createContact(data);
            System.debug('Created contact: '+ contactId);            
        }
        

        // You'd likely use other logic to assign the Profile
        Profile p = [SELECT Id FROM profile WHERE name=:EXTERNAL_USER_PROFILE];
        System.debug('Found profile: '+ p);

        // Keeping it modular, we initialize the user in another method
        User u = createUser(data,p);
        
        //assigning permission set to the user by rr team
        
        
        assignPermissionSet(data.email);
        system.debug('User Id from create User is '+u.id);
        u.contactId = contactId;
        
        
        
        return u;
    } else {
        //This is not a community, so we Assign an internal profile
        Profile p = [SELECT Id FROM profile WHERE name=:INTERNAL_USER_PROFILE];
        System.debug('Found profile: '+ p);
        
        // Keeping it modular, we initialize the user in another method
        User u = createUser(data,p);

        return u;
    }
}

/**
 * Update the user
 * @param portalId  - Id of the Community
 * @param data - Auth Provider user data describing the User to create
 **/     
global void updateUser(Id userId, Id portalId, Auth.UserData data){
    System.debug('Update User called for: ' + data.email);
    
    User u = new User(id=userId);
    u.email = data.email;
    u.lastName = data.lastName;
    u.firstName = data.firstName;
    assignPermissionSet(data.email);
    update(u);
}
    /**
     * Create a Contact
     * 
     * @param data - Facebook provided context for the User
     **/
    private Id createContact(Auth.UserData data){
        Contact contact = new Contact();
        contact.LastName = data.lastName;
        contact.FirstName = data.firstName;
        contact.Email = data.email;
        
        // set Account Id
        if (data.attributemap.get('accountId') != null){
            contact.accountId = data.attributemap.get('accountId');
        } else {
            List<Account> accounts = [select Id from Account where Name =:DEFAULT_ACCOUNTNAME];
            System.debug('Found account: ' + accounts);
            
            contact.accountId = accounts[0].Id;            
        }
        // we are adding the employee look up field in contact here 
        Employee__c employee=[SELECT Id,Name , Email__c from Employee__c WHERE Email__c =:data.email].get(0);
        contact.Employee__c=employee.Id;
         insert contact;

        System.debug('Contact created for ' + data.email + ' id=' + contact.id);

        return contact.id; 
    }

    
    /**
     * Create and initialize the User but don't save it yet
     * 
     * @param data - the provided User context from FaceBook
     * @param p - the Profile we are going to assign to this user
     * 
     * @return User that has been initialized but not Saved
     **/ 
    private User createUser(Auth.UserData data, Profile p) {
        User u = new User();
        u.username = data.email + 'xyz' + ORG_SUFFIX;
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        String alias = data.firstName + data.lastName;
        
        
        //Alias must be 8 characters or less
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        u.alias = alias;
        u.languagelocalekey = UserInfo.getLanguage();
        u.localesidkey = UserInfo.getLocale();
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = TZSID;
        u.profileId = p.Id;
        return u;    
        
    }  
    
    @future(callout=true)
    public static void assignPermissionSet(String userEmail){
    
     User u =[select Id from user where email=:userEmail].get(0);
        
        
     Id permissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'RR_Customer_User'].Id;

    
    List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
    
                psaList.add(new PermissionSetAssignment(PermissionSetId=permissionSetId, AssigneeId=u.Id));
                Database.SaveResult[] srList = Database.insert(psaList, false);
                if (srList[0].isSuccess()) {
                    System.debug('Permission set assigned successfully to  user: ' + u.Id);
                } else {
                    System.debug('Failed to assign permission set to user: ' + u.Id);
                }
    
    } 
         
}