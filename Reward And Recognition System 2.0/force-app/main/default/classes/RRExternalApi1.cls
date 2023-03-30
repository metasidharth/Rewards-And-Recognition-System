@RestResource(urlMapping='/SubmitFeedback1/')
global class RRExternalApi1 {
    @HttpPost
    global static String SubmitFeedback(List<FeedbackDetails> data) {
        
        insertEmployee(data);
        insertCategory(data);
        insertQuarter(data);
        insertSubCategory(data);
        insertSystem(data);
        insertSystemConfiguration(data);
        insertFeedback(data);
        
        return 'Success';
    }
    
    public static void insertEmployee(List<FeedbackDetails> data){
        Map<String, Employee__c> existingEmployee = new Map<String, Employee__c>();
        for(Employee__c emp : [SELECT Name, First_Name__c, Last_Name__c, Employee_Id__c FROM Employee__c]){
            existingEmployee.put(emp.Employee_Id__c, emp);
        }
        List<Employee__c> newEmployeeList=new List<Employee__c>();
        for(FeedbackDetails feedback:data){
            if(!existingEmployee.keySet().contains(feedback.employeeId)){
                Employee__c newEmp=new Employee__c();
                newEmp.First_Name__c=feedback.firstName;
                newEmp.Last_Name__c=feedback.lastName;
                newEmp.Name=feedback.firstName+' '+feedback.lastName;
                newEmp.Employee_Id__c=feedback.employeeId;
                newEmployeeList.add(newEmp);
            }
        }
        System.debug(newEmployeeList);
        insert newEmployeeList;
    }
    
    public static void insertCategory(List<feedBackDetails> data){
        Map<String,Category__c> existingCategory=new Map<String,Category__c>();
        for(Category__c cat:[select Name From Category__c]){
            existingCategory.put(cat.Name,cat);
        }
        List<Category__c> newCategoryList=new List<Category__c>();
        for(feedbackDetails feedback:data){
            if(!existingCategory.keySet().contains(feedback.category)){
                Category__c newCat=new Category__c();
                newCat.Name=feedback.category;
                newCategoryList.add(newCat);
            }
        }
        insert newCategoryList;
    }
    
    public static void insertQuarter(List<FeedbackDetails> data){
        Map<String,Quarter__c> existingQuarters = new Map<String,Quarter__c>();
        for(Quarter__c quarter : [SELECT Name from Quarter__c]){
            existingQuarters.put(quarter.Name,quarter);
        }
        List<Quarter__c> newQuarterList= new List<Quarter__c>();
        
        for(FeedbackDetails feedback:data){
            if(!existingQuarters.keySet().contains(feedback.quarter)){
                Quarter__c newQuarter = new Quarter__c();
                newQuarter.Name= feedback.quarter;
                newQuarterList.add(newQuarter);
            }
        }
        insert newQuarterList;
    }
    
    public static void insertSubCategory(List<FeedbackDetails> data){
        List<Category__c> categoryList=[select Id, Name from Category__c];
        Map<String,Sub_Category__c> existingSubCategory = new Map<String,Sub_Category__c>();
        for(Sub_Category__c subCategory : [SELECT Name from Sub_Category__c]){
            existingSubCategory.put(subCategory.Name,subCategory);
        }
        List<Sub_Category__c> newSubCategoryList=new List<Sub_Category__c>();
        for(feedbackDetails feedback:data){
            if(!existingSubCategory.keySet().contains(feedback.subCategory)){
                Sub_Category__c newSubCategory=new Sub_Category__c();
                newSubCategory.Name=feedback.subCategory;
                for(Category__c cat:CategoryList){
                    if(cat.Name==feedback.category){
                        newSubCategory.Category__c=cat.Id;
                    }
                }
                newSubCategoryList.add(newSubCategory);
            }
        }
        insert newSubCategoryList;
    }
    
    public static void insertSystem(List<FeedbackDetails> data){
        Map<String,System__c> existingSystems = new Map<String,System__c>();
        for(System__c sys : [SELECT Name,System_Description__c,Owner_Email__c from System__c]){
            existingSystems.put(sys.Name,sys);
        }
        List<System__c> newSystemList= new List<System__c>();
        
        for(FeedbackDetails feedback:data){
            if(!existingSystems.keySet().contains(feedback.systems)){
                System__c newSystem = new System__c();
                newSystem.Name= feedback.systems;
                newSystem.Owner_Email__c= feedback.systemOwnerEmail;
                newSystem.System_Description__c=feedback.systemDescription;
                newSystemList.add(newSystem);
            }
        }
        insert newSystemList;
    }
    public static void insertSystemConfiguration(List<FeedbackDetails> data){
        List<System_Configuration__c> newSystemConfigList=new List<System_Configuration__c>();
        
        Map<String,System_Configuration__c> sysConfigMap = new Map<String,System_Configuration__c>();
        for(System_Configuration__c sysConfig : [select name ,Category__r.name, Sub_Category__r.name,System__r.name,Points__c from System_Configuration__c]){
            String key=sysConfig.System__r.name+sysConfig.Category__r.name+sysConfig.Sub_Category__r.name;
            sysConfigMap.put(key,sysConfig);
            // System.debug('the Keys are '+key);
        }
        
        Map<String,Category__c> categoryMap=new Map<String,Category__c>();
        for(Category__c cat:[select Name From Category__c]){
            categoryMap.put(cat.Name,cat);
        }
        Map<String,Sub_Category__c> subCategoryMap=new Map<String,Sub_Category__c>();
        for(Sub_Category__c cat:[select Name From Sub_Category__c]){
            subCategoryMap.put(cat.Name,cat);
        }
        Map<String,System__c> systemMap = new Map<String,System__c>();
        for(System__c sys : [SELECT Name,System_Description__c,Owner_Email__c from System__c]){
            systemMap.put(sys.Name,sys);
        }
        
        for(FeedbackDetails newdata:data){
            if(!sysConfigMap.keyset().contains(newData.systems+newData.category+newdata.subCategory)){
                System_Configuration__c newSystemConfig=new System_Configuration__c();
                newSystemConfig.System__c=systemMap.get(newData.systems).Id;
                newSystemConfig.Category__c=categorymap.get(newData.category).Id;
                newSystemConfig.Sub_Category__c=subCategoryMap.get(newData.subCategory).Id;
                newSystemConfig.Name=newData.systems+','+newData.category+','+newData.subCategory;
                newSystemConfig.Unit_Type__c=newData.unitType;
                newSystemConfig.Rating_Unit__c=1;
                newSystemConfigList.add(newSystemConfig);
            }
        }
        insert newSystemConfigList;
    }
    
    
    public static void insertFeedback(List<FeedbackDetails> data){
        List<Feedback__c> newFeedbackList=new List<Feedback__c>();
        
        Map<String,Feedback__c> existingFeedback = new Map<String,Feedback__c>();
        for(Feedback__c feedback : [SELECT Name,System_Configuration__c,Rating__c,Quarter__c,Employee__r.Employee_Id__c from Feedback__c]){ 
            String feedbackKey = String.valueOf(feedback.Employee__r.Employee_Id__c) + String.valueOf(feedback.System_Configuration__c) + String.valueOf(feedback.Quarter__c);
            existingFeedback.put(feedbackKey, feedback);
        }
        
        Map<String,Quarter__c> quarterMap = new Map<String,Quarter__c>();
        for(Quarter__c quarter : [SELECT Name from Quarter__c]){
            quarterMap.put(quarter.Name,quarter);
        }
        
        Map<String,Category__c> categoryMap=new Map<String,Category__c>();
        for(Category__c cat:[select Name From Category__c]){
            categoryMap.put(cat.Name,cat);
        }
        Map<String,Sub_Category__c> subCategoryMap=new Map<String,Sub_Category__c>();
        for(Sub_Category__c cat:[select Name From Sub_Category__c]){
            subCategoryMap.put(cat.Name,cat);
        }
        
        Map<String,System__c> systemMap = new Map<String,System__c>();
        for(System__c sys : [SELECT Name,System_Description__c,Owner_Email__c from System__c]){
            systemMap.put(sys.Name,sys);
        }
        
        Map<String,System_Configuration__c> SysConfigMap = new Map<String,System_Configuration__c>();
        for(System_Configuration__c sysConfig : [select name ,Category__r.name, Sub_Category__r.name,System__r.name,Points__c from System_Configuration__c]){
            String key=sysConfig.System__r.name+sysConfig.Category__r.name+sysConfig.Sub_Category__r.name;
            SysConfigMap.put(key,sysConfig);
            // System.debug('the Keys are '+key);
        }
        // System.debug('the system from data is '+SysConfigMap.get(data[0].systems+data[0].category+data[0].subCategory));
        
        
        Map<String, Employee__c> employeeMap = new Map<String, Employee__c>();
        for(Employee__c emp : [SELECT Name, First_Name__c, Last_Name__c, Employee_Id__c FROM Employee__c]){
            employeeMap.put(emp.Employee_Id__c, emp);
        }
        
        
        for(FeedbackDetails newData:data){
            System.debug('the employee is '+ employeeMap.get(newData.employeeId));
            System.debug('The quarter is '+quarterMap.get(newData.quarter));
            System.debug('the system Configuration is '+String.valueOf(SysConfigMap.get(newData.systems+newData.category+newdata.subCategory).Id));
            
            
            if(existingFeedback.keySet().contains(newData.employeeId+String.valueOf(SysConfigMap.get(newData.systems+newData.category+newdata.subCategory).Id)+String.valueOf(quarterMap.get(newData.quarter).Id))){
                Feedback__c updateFeedback=existingFeedback.get(newData.employeeId+String.valueOf(SysConfigMap.get(newData.systems+newData.category+newdata.subCategory).Id)+String.valueOf(quarterMap.get(newData.quarter).Id));
                updateFeedback.Rating__c+=Integer.valueOf(newData.rating);
                newFeedbackList.add(updateFeedback);
            }
            else{
                Feedback__c newFeedback=new Feedback__c();
                newFeedback.Employee__c=employeeMap.get(newData.employeeId).Id;
                newFeedback.Date__c=Date.Today();
                newFeedback.Description__c=newData.description;
                newFeedback.Quarter__c=quarterMap.get(newData.quarter).Id;
                newFeedback.System_Configuration__c=SysConfigMap.get(newData.systems+newData.category+newData.subCategory).Id;
                newFeedback.Rating__c=Integer.valueOf(newData.rating);
                
                newFeedbackList.add(newFeedback);
                
            }
        }
        List<Database.UpsertResult>insertRecords=Database.upsert(newFeedbackList,false); 
        
        Integer count=0;
        for (Integer i = 0; i < insertRecords.size(); i++) {
            if (insertRecords[i].isSuccess()) {
                System.debug('Record with ID ' + insertRecords[i].getId() + ' was inserted successfully.');
            } else {
                Database.Error err = insertRecords[i].getErrors()[0];
                System.debug('Record with ID ' + insertRecords[i].Id + ' failed to insert with error: the count is '+ count++ + + err.getMessage());
            }
        }
    }
    
    global class FeedbackDetails{
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String rating { get; set; }
        public String unitType { get; set; }
        public String category { get; set; }
        public String quarter { get; set; }
        public String systems { get; set; }
        public String systemDescription {get;set;}
        public String systemOwnerEmail{get;set;}
        public String subCategory { get; set; }
        public String employeeId { get; set; }
        public String description { get; set; }
        
    }
    
    @HttpGet
    global static List<Employee_Badge__c> getFeedback() {
        return [SELECT name, Category__r.name,Employee__r.name ,Employee__r.Employee_Id__c,
                Assigned_Badge__r.title__c, Assigned_Badge__r.Image__c
                from Employee_Badge__c];
    }
}