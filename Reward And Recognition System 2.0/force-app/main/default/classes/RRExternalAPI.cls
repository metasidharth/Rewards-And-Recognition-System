/*
 *
*/
@RestResource(urlMapping='/SubmitFeedback/')
global with sharing class RRExternalAPI {

   @HttpPost
   global static String SubmitFeedback(String unitType,String name, String quarter, String systems, String rating, String description, String employeeId, String category, String subCategory) {
        insertEmployee(name,employeeId);
        insertCategory(category);
        insertSubCategory(subCategory,category);
        insertQuarter(quarter);
        insertSystem(systems);
        insertSystemConfiguration( systems,rating,category, subCategory, unitType );
     	insertFeedback(name,quarter,rating ,description,employeeId,category,subCategory,systems);
        return 'success';
   }

     private static void insertEmployee(String name , String employeeId){
        List<Employee__c> employeeList=[select Name,Employee_Id__c from Employee__c ];
        List<String> EmployeeIdList=new List<String>();
        for(Employee__c emp:employeeList){
            EmployeeIdList.add(emp.Employee_Id__c);
        }
        String employeeIdString=String.join(EmployeeIdList,',');
        if(!employeeIdString.contains(employeeId)) {
            Employee__c employee=new Employee__c(Name=name,Employee_Id__c=employeeId, Is_Active__c=true );
            insert employee;
        }
     }

    private static void insertCategory(String category){
        List<Category__c> categoryList=[select Name from Category__c];
        List<String> categoryNameList=new List<String>();
        for(Category__c ct:categoryList){
            categoryNameList.add(ct.Name);
        }
        if(!categoryNameList.contains(category)) {

            Category__c newCategory=new Category__c(Name=category);
            insert newCategory;
        }
     }

     private static void insertSubCategory(String subCategory, String category ){
        List<Sub_Category__c> subCategoryList=[select Name from Sub_Category__c];
        List<String> subCategoryNameList=new List<String>();
        for(Sub_Category__c ct:subCategoryList){
            subCategoryNameList.add(ct.Name);
        }
        if(!subCategoryNameList.contains(subCategory)) {
            Id catId=[select name from category__c where name like :category].get(0).id;
            Sub_Category__c newSubCategory=new Sub_Category__c(Name=subCategory,category__c=catId);
            insert newSubCategory;
        }
     }

    private static void insertQuarter(String quarter){
        List<Quarter__c> quarterList=[select Name from Quarter__c];
        List<String> quarterNameList=new List<String>();
        for(Quarter__c ct:quarterList){
            quarterNameList.add(ct.Name);
        }
        if(!quarterNameList.contains(quarter)) {
            Quarter__c newQuarter=new Quarter__c(Name=quarter);
            insert newQuarter;
        }
     }

    private static void insertSystem(String systems){
        List<System__c> systemList=[select Name from System__c];
        List<String> systemNameList=new List<String>();
        for(System__c ct:systemList){
            systemNameList.add(ct.Name);
        }
        if(!systemNameList.contains(systems)){
            System__c newQuarter=new System__c(Name=systems);
            insert newQuarter;
        }
     }

    private static void insertSystemConfiguration(String systems ,String rating,String category,String subCategory,String unitType ){

  List<System_Configuration__c> sysConfigList=[select name ,Category__c,Sub_Category__c, System__c from System_Configuration__c ];

       Id catId = [SELECT Id FROM Category__c WHERE Name LIKE :category LIMIT 1].Id;
       Id subCatId = [SELECT Id FROM Sub_Category__c WHERE Name LIKE :subCategory LIMIT 1].Id;
       Id sysId = [SELECT Id FROM System__c WHERE Name LIKE :systems LIMIT 1].Id;

        String combineParameterString = String.valueOf(catId) + String.valueOf(subCatId) + String.valueOf(sysId);


         List<String> combineIdList=new List<String>();

       for(System_Configuration__c sc:sysConfigList){
          String joinedString='';
           joinedString+=String.valueOf(sc.Category__c)+String.valueOf(sc.Sub_Category__c)+String.valueOf(sc.System__c);
          combineIdList.add(joinedString);
       }

       if(!combineIdList.contains(combineParameterString)){
        System_Configuration__c newConfig=new System_Configuration__c();
        newConfig.name=systems+','+category+','+subcategory;   
        newConfig.Category__c=catId;
        newConfig.Sub_Category__c=subCatId;
        newConfig.System__c=sysId;
        newConfig.Unit_Type__c=unitType;
        newConfig.Rating_Unit__c=1;  
           newConfig.Points__c=Integer.valueOf(rating);
        insert newConfig;
       }
}
    
    private static void insertFeedback(String name,String quarter,String rating , String description, String employeeId, String category, String subCategory, String systems){


        Id empId = [select name from Employee__c where Employee_Id__c like: employeeId ].get(0).Id;
        Id quarterID = [select name from Quarter__c where name like:quarter].get(0).Id;
        Id SysconfigId=[select name from System_Configuration__c where Category__r.name like :category And
                      Sub_Category__r.name like :subCategory And system__r.name like :systems].get(0).Id;
        Id employeeIds=[select id from Employee__c where Employee_Id__c like :employeeId].get(0).Id;
       
        List<Feedback__c> feedbackList=[select name ,Rating__c , System_Configuration__c ,Quarter__c,Employee__c from Feedback__c ];
        for(Feedback__c feedback:feedbackList){
            if(feedback.Employee__c==employeeIds  && feedback.System_Configuration__c==SysconfigId && feedback.Quarter__c==quarterID ){
                feedback.Rating__c+=Integer.valueOf(rating);
                update feedback;
                return ;
            }
        }
        
        Feedback__c newFeedback = new Feedback__c();
        newFeedback.Rating__c=Integer.valueOf(rating);
        newFeedback.Date__c=Date.today();
        newFeedback.Description__c=description;
        newFeedback.System_Configuration__c=sysConfigId;
        newfeedback.Quarter__c=quarterID;
        newFeedback.Employee__c=empId;
        insert newfeedback;
        

   }
    
    



    @HttpGet
    global static List<Feedback__c> getFeedback() {
         return [SELECT Id, Rating__c, description__c, System_Configuration__c FROM Feedback__c];
     }
}