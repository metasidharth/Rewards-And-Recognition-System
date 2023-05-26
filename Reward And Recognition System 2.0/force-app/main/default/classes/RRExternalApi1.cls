@RestResource(urlMapping='/Feedback/')
global class RRExternalApi1 {
    
    
    @HttpPost
    global static String submitFeedback(List<FeedbackDetails> data) {
        
        insertEmployee(data);
        insertCategory(data);
        insertQuarter(data);
        insertSubCategory(data);
        insertSystem(data);
        insertSystemConfiguration(data);
        return insertFeedback(data);
    }
    
    // function to insert new employee  object from feedback data
    public static void insertEmployee(List<FeedbackDetails> data){
        Map<String, Employee__c> existingEmployee = new Map<String, Employee__c>();
        //query  exixting employees from database
        SelectorForEmployeeAPI employeeList= new SelectorForEmployeeAPI();
        for(Employee__c emp : employeeList.getEmployee()){
            existingEmployee.put(emp.Employee_Id__c, emp);
        }
        
        //for(Employee__c emp : [SELECT Name, First_Name__c, Last_Name__c, Employee_Id__c FROM Employee__c]){
        //  existingEmployee.put(emp.Employee_Id__c, emp);
        //}
        
        
        Set<Employee__c> newEmployeeSet=new Set<Employee__c>();
        for(FeedbackDetails feedback:data){
            if(!existingEmployee.keySet().contains(feedback.employeeId)){
                Employee__c newEmp=new Employee__c();
                newEmp.First_Name__c=feedback.firstName;
                newEmp.Last_Name__c=feedback.lastName;
                newEmp.Name=feedback.firstName+' '+feedback.lastName;
                newEmp.Employee_Id__c=feedback.employeeId;
                newemp.Email__c=feedback.email;
                newEmployeeSet.add(newEmp);
            }
        }
        
        List<Employee__c> newEmployeeList= new List<Employee__c>(newEmployeeSet);
        insert newEmployeeList;
    }
    
    // function to insert new category object from feedback data
    public static void insertCategory(List<feedBackDetails> data){
        Map<String,Category__c> existingCategory=new Map<String,Category__c>();
        
        SelectorForCategory catList=new SelectorForCategory();
        for(Category__c cat: catList.getCategory()){
            existingCategory.put(cat.Name,cat);
        }
        
        //for(Category__c cat:[select Name From Category__c]){
        //  existingCategory.put(cat.Name,cat);
        //}
        
        Set<Category__c> newCategorySet=new Set<Category__c>();
        
        for(feedbackDetails feedback:data){
            if(!existingCategory.keySet().contains(feedback.category)){
                Category__c newCat=new Category__c();
                newCat.Name=feedback.category;
                newCategorySet.add(newCat);
            }
        }
        
        List<Category__c> newCategoryList=new List<Category__c>(newCategorySet);
        
        insert newCategoryList;
        
    }
    
    // function to insert new quarter from feedback data in Quarter__c object
    public static void insertQuarter(List<FeedbackDetails> data){
        Map<String,Quarter__c> existingQuarters = new Map<String,Quarter__c>();
        SelectorForQuarter QuarterList=new SelectorForQuarter ();
        
        for(Quarter__c quarter :QuarterList.getQuarter()){
            existingQuarters.put(quarter.Name,quarter);
        }
        
        //for(Quarter__c quarter : [SELECT Name from Quarter__c]){
        //  existingQuarters.put(quarter.Name,quarter);
        //}
        //
        Set<Quarter__c> newQuarterSet= new Set<Quarter__c>();
        
        for(FeedbackDetails feedback:data){
            if(!existingQuarters.keySet().contains(feedback.quarter)){
                Quarter__c newQuarter = new Quarter__c();
                newQuarter.Name= feedback.quarter;
                newQuarterSet.add(newQuarter);
            }
        }
        
        List<Quarter__c> newQuarterList = new List<Quarter__c>(newQuarterSet);
        
        insert newQuarterList;
    }
    
    // function to insert new subCategory from feedback data in Sub_Category__c object
    public static void insertSubCategory(List<FeedbackDetails> data){
        SelectorForCategory catList=new SelectorForCategory();
        List<Category__c> categoryList=catList.getCategory();
        // List<Category__c> categoryList=[select Id, Name from Category__c];
        SelectorForSubCategory subCategoryList = new SelectorForSubCategory();
        
        Map<String,Sub_Category__c> existingSubCategory = new Map<String,Sub_Category__c>();
        for(Sub_Category__c subCategory : subCategoryList.getSubCategoryForRRAPI()){
            existingSubCategory.put(subCategory.Name,subCategory);
        }
        
        
        //for(Sub_Category__c subCategory : [SELECT Name from Sub_Category__c]){
        //  existingSubCategory.put(subCategory.Name,subCategory);
        //}
        
        Set<Sub_Category__c> newSubCategorySet=new Set<Sub_Category__c>();
        for(feedbackDetails feedback:data){
            if(!existingSubCategory.keySet().contains(feedback.subCategory)){
                Sub_Category__c newSubCategory=new Sub_Category__c();
                newSubCategory.Name=feedback.subCategory;
                for(Category__c cat:CategoryList){
                    if(cat.Name==feedback.category){
                        newSubCategory.Category__c=cat.Id;
                    }
                }
                newSubCategorySet.add(newSubCategory);
            }
        }
        List<Sub_Category__c> newSubCategoryList = new List<Sub_Category__c>(newSubCategorySet);
        insert newSubCategoryList;
        
    }
    
    // function to insert new system in system__c object
    public static void insertSystem(List<FeedbackDetails> data){
        Map<String,System__c> existingSystems = new Map<String,System__c>();
        SelectorForSystemRRAPI systemList= new SelectorForSystemRRAPI();
        
        
        for(System__c sys : systemList.getSystem()){
            existingSystems.put(sys.Name,sys);
        }
        
        // for(System__c sys : [SELECT Name,Approver_Email__c from System__c]){
        //     existingSystems.put(sys.Name,sys);
        // }
        Set<System__c> newSystemSet= new Set<System__c>();
        
        for(FeedbackDetails feedback:data){
            if(!existingSystems.keySet().contains(feedback.systems)){
                System__c newSystem = new System__c();
                newSystem.Name= feedback.systems;
                // newSystem.Approver_Email__c= feedback.systemOwnerEmail;
                //newSystem.System_Description__c=feedback.systemDescription;
                newSystemSet.add(newSystem);
            }
        }
        List<System__c> newSystemList = new List<System__c>(newSystemSet);
        insert newSystemList;
        
    }
    
    // function to insert system configuration in System_Configuration__c
    public static void insertSystemConfiguration(List<FeedbackDetails> data){
        Set<System_Configuration__c> newSystemConfigSet=new Set<System_Configuration__c>();
        
        Map<String,System_Configuration__c> sysConfigMap = new Map<String,System_Configuration__c>();
        
        SelectorForSystemConfiguration SysConfigList=new SelectorForSystemConfiguration();
        for(System_Configuration__c sysConfig :SysConfigList.getSystemConfiguration() ){
            System.debug('the system config is'+sysConfig.Category__r.Name );
            String key=sysConfig.System__r.name+sysConfig.Category__r.name+sysConfig.Sub_Category__r.name;
            sysConfigMap.put(key,sysConfig);
            System.debug('the Keys are '+key);
        }
        
        // for(System_Configuration__c sysConfig : [select name ,Category__r.name, Sub_Category__r.name,System__r.name,Points__c from System_Configuration__c]){
        //  String key=sysConfig.System__r.name+sysConfig.Category__r.name+sysConfig.Sub_Category__r.name;
        // sysConfigMap.put(key,sysConfig);
        // System.debug('the Keys are '+key);
        //  }
        
        SelectorForCategory catList=new SelectorForCategory();
        Map<String,Category__c> categoryMap=new Map<String,Category__c>();
        for(Category__c cat:catList.getCategory()){
            categoryMap.put(cat.Name,cat);
        }
        // for(Category__c cat:[select Name From Category__c]){
        //     categoryMap.put(cat.Name,cat);
        // }
        
        
        SelectorForSubCategory  subcatList=new SelectorForSubCategory();
        Map<String,Sub_Category__c> subCategoryMap=new Map<String,Sub_Category__c>();
        for(Sub_Category__c cat:subcatList.getSubCategoryForRRAPI()){
            subCategoryMap.put(cat.Name,cat);
        }
        // for(Sub_Category__c cat:[select Name From Sub_Category__c]){
        //     subCategoryMap.put(cat.Name,cat);
        // }
        
        
        SelectorForSystemRRAPI systemList= new SelectorForSystemRRAPI();
        Map<String,System__c> systemMap = new Map<String,System__c>();
        for(System__c sys :systemList.getSystem()){
            systemMap.put(sys.Name,sys);
        }
        // for(System__c sys : [SELECT Name,Approver_Email__c from System__c]){
        //     systemMap.put(sys.Name,sys);
        // }
        
        for(FeedbackDetails newdata:data){
            if(!sysConfigMap.keyset().contains(newData.systems+newData.category+newdata.subCategory)){
                System_Configuration__c newSystemConfig=new System_Configuration__c();
                newSystemConfig.System__c=systemMap.get(newData.systems).Id;
                newSystemConfig.Category__c=categorymap.get(newData.category).Id;
                newSystemConfig.Sub_Category__c=subCategoryMap.get(newData.subCategory).Id;
                newSystemConfig.Name=newData.systems+','+newData.category+','+newData.subCategory;
                newSystemConfig.Unit_Type__c=newData.unitType;
                newSystemConfig.Rating_Unit__c=1;
                newSystemConfigSet.add(newSystemConfig);
            }
        }
        List<System_Configuration__c> newSystemConfigList=new List<System_Configuration__c>(newSystemConfigSet);
        insert newSystemConfigList;
    }
    
    // function to insert feedback in feedback__c object
    public static String insertFeedback(List<FeedbackDetails> data){
        List<Feedback__c> newFeedbackList=new List<Feedback__c>();
        SelectorForFeedback feedbackSelector=new  SelectorForFeedback();
        Map<String,Feedback__c> existingFeedback = new Map<String,Feedback__c>();
        
        for(Feedback__c feedback : feedbackSelector.getFeedback()){
            String feedbackKey = String.valueOf(feedback.Employee__r.Employee_Id__c) + String.valueOf(feedback.System_Configuration__c) + String.valueOf(feedback.Quarter__c);
            existingFeedback.put(feedbackKey, feedback);
        }
        
        /*
         for(Feedback__c feedback : [SELECT Name,System_Configuration__c,Rating__c,Quarter__c,Employee__r.Employee_Id__c from Feedback__c]){
             String feedbackKey = String.valueOf(feedback.Employee__r.Employee_Id__c) + String.valueOf(feedback.System_Configuration__c) + String.valueOf(feedback.Quarter__c);
             existingFeedback.put(feedbackKey, feedback);
         }
        */
       
        SelectorForQuarter quarterList= new SelectorForQuarter();
        Map<String,Quarter__c> quarterMap = new Map<String,Quarter__c>();
        for(Quarter__c quarter : quarterList.getQuarter()){
            quarterMap.put(quarter.Name,quarter);
        }
        
        /*
        for(Quarter__c quarter : [SELECT Name from Quarter__c]){
            quarterMap.put(quarter.Name,quarter);
         }
         */
        
        
        SelectorForCategory catList=new SelectorForCategory();
        Map<String,Category__c> categoryMap=new Map<String,Category__c>();
        for(Category__c cat:catList.getCategory()){
            categoryMap.put(cat.Name,cat);
        }
        /*
         for(Category__c cat:[select Name From Category__c]){
             categoryMap.put(cat.Name,cat);
         }
         */
        
        SelectorForSubCategory subCatList=new SelectorForSubCategory();
        Map<String,Sub_Category__c> subCategoryMap=new Map<String,Sub_Category__c>();
        for(Sub_Category__c cat:subCatList.getSubCategoryForRRAPI()){
            subCategoryMap.put(cat.Name,cat);
        }
        /*
         for(Sub_Category__c cat:[select Name From Sub_Category__c]){
             subCategoryMap.put(cat.Name,cat);
         }
        */
        
        SelectorForSystemRRAPI sysList=new SelectorForSystemRRAPI();
        Map<String,System__c> systemMap = new Map<String,System__c>();
        for(System__c sys : sysList.getSystem()){
            systemMap.put(sys.Name,sys);
        }
        /*
         for(System__c sys : [SELECT Name,Approver_Email__c  from System__c]){
             systemMap.put(sys.Name,sys);
         }	
		*/
        
        SelectorForSystemConfiguration sysConfigList=new SelectorForSystemConfiguration();
        Map<String,System_Configuration__c> SysConfigMap = new Map<String,System_Configuration__c>();
         for(System_Configuration__c sysConfig :sysConfigList.getSystemConfiguration() ){
             String key=sysConfig.System__r.name+sysConfig.Category__r.name+sysConfig.Sub_Category__r.name;
             SysConfigMap.put(key,sysConfig);
              System.debug('the Keys are '+key);
         }
         /*
        for(System_Configuration__c sysConfig : [select name ,Category__r.name, Sub_Category__r.name,System__r.name,Points__c from System_Configuration__c]){
            String key=sysConfig.System__r.name+sysConfig.Category__r.name+sysConfig.Sub_Category__r.name;
            SysConfigMap.put(key,sysConfig);
             System.debug('the Keys are '+key);
        }
        */
        
        System.debug('the system from data is '+SysConfigMap.get(data[0].systems+data[0].category+data[0].subCategory));  
        SelectorForEmployeeAPI empList= new SelectorForEmployeeAPI();
        Map<String, Employee__c> employeeMap = new Map<String, Employee__c>();
        for(Employee__c emp :empList.getEmployee()){
            employeeMap.put(emp.Employee_Id__c, emp);
        }
        /*
         for(Employee__c emp : [SELECT Name, First_Name__c,Email__c ,Last_Name__c, Employee_Id__c FROM Employee__c]){
             employeeMap.put(emp.Employee_Id__c, emp);
         }
       */
        
        Map<String,FeedbackDetails> feedbackMap = new Map<String,FeedbackDetails>();
        for(FeedbackDetails newMapData : data){
            String feedKey= newMapData.employeeId + ',' + newMapData.systems + ',' + newMapData.category + ',' + newMapData.subCategory + ',' + newMapData.quarter;
            if(FeedbackMap.KeySet().contains(feedKey)){
                Decimal newRating=Decimal.valueOf(newMapData.rating)+Decimal.valueOf(FeedbackMap.get(feedkey).rating);
                newMapData.rating=String.valueOf(newRating);
                feedbackMap.put(feedKey,newMapData);
            }
            else{
                feedbackMap.put(feedKey,newMapData);
            }
        }
        System.debug(feedbackMap);
        
        List<FeedbackDetails> revisedDataList= new List<FeedbackDetails>();
        for(String key:feedbackMap.keySet()){
            revisedDataList.add(feedBackMap.get(key));
        }
        for(FeedbackDetails newData:revisedDataList){
            
            
            //System.debug('the employee is '+ employeeMap.get(newData.employeeId));
            //System.debug('The quarter is '+quarterMap.get(newData.quarter));
            //System.debug('the system Configuration is '+String.valueOf(SysConfigMap.get(newData.systems+newData.category+newdata.subCategory).Id));
            
            if(existingFeedback.keySet().contains(newData.employeeId+String.valueOf(SysConfigMap.get(newData.systems+newData.category+newdata.subCategory).Id)+String.valueOf(quarterMap.get(newData.quarter).Id))){
                Feedback__c updateFeedback=existingFeedback.get(newData.employeeId+String.valueOf(SysConfigMap.get(newData.systems+newData.category+newdata.subCategory).Id)+String.valueOf(quarterMap.get(newData.quarter).Id));
                updateFeedback.Rating__c+=Integer.valueOf(newData.rating);
                updateFeedback.Raw_Request__c=JSON.serialize(newData);
                newFeedbackList.add(updateFeedback);
            }
            else{
                Feedback__c newFeedback=new Feedback__c();
                newFeedback.Employee__c=employeeMap.get(newData.employeeId).Id;
                //newFeedback.Employee_Image__c=newData.employeeImage;
                newFeedback.Date__c= Date.valueOf(newData.feedbackDate);
                newFeedback.Description__c=newData.description;
                newFeedback.Quarter__c=quarterMap.get(newData.quarter).Id;
                newFeedback.System_Configuration__c=SysConfigMap.get(newData.systems+newData.category+newData.subCategory).Id;
                newFeedback.Rating__c=Integer.valueOf(newData.rating);
                newFeedback.Raw_Request__c  =JSON.serialize(newData);
                newFeedbackList.add(newFeedback);
                
            }
        }
        // List<Feedback__c> newFeedbackList1 = new List<Feedback__c>(newFeedbackList);
        List<Database.UpsertResult>insertRecords=Database.upsert(newFeedbackList,false);
        String errorRecords='';
        Integer count=0;
        for (Integer i = 0; i < insertRecords.size(); i++) {
            if (insertRecords[i].isSuccess()) {
                System.debug('Record with ID ' + insertRecords[i] + ' was inserted successfully.');
                
            } else {
                Database.Error err = insertRecords[i].getErrors()[0];
                System.debug('Record failed to insert with the following error:  Error Message = ' + err.getMessage()+' ');
                errorRecords+='Record failed to insert with the following error: Error Message = ' + err.getMessage()+' ';
            }
            
        }
        // if(count==insertRecords.size()){
        //errorRecords='Success';
        //}
        return errorRecords;
    }
    
    
    global class FeedbackDetails{
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String email {get;set;}
        public String rating { get; set; }
        public String unitType { get; set; }
        public String category { get; set; }
        public String quarter { get; set; }
        public String systems { get; set; }
        public String feedbackDate { get; set; }
        public String employeeImage { get; set; }
        //public String systemDescription {get;set;}
        public String systemOwnerEmail{get;set;}
        public String subCategory { get; set; }
        public String employeeId { get; set; }
        public String description { get; set; }
        public String rawRequest{get;set;}
        
        
    }
    
    
    
}