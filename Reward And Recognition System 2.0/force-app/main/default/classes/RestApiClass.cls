@RestResource(urlMapping='/Feedback__c/')
global with sharing class RestApiClass {

//    @HttpPost
//     global static String insertAllData(String name,String quarter,String systems,String rating , String description, String metacubeId,String category,String subCategory) {
//         insertEmployee(name,metacubeId);
//         insertCategory(category);
//         insertSubCategory(subCategory,category);
//         insertQuarter(quarter);
//         insertSystem(systems);
//         insertReceivedFeedback(name,quarter,systems,rating ,description,metacubeId,category,subCategory);
//         return 'success ';
//     }

//      public static void insertEmployee(String name , String metacubeId){
//         List<Employee__c> employeeList=[select Name,Metacube_Employee_Id__c from Employee__c ];
//         List<String> EmployeeIdList=new List<String>();
//         for(Employee__c emp:employeeList){
//             EmployeeIdList.add(emp.metacube_Employee_Id__c);
//         }
//         String employeeIdString=String.join(EmployeeIdList,',');
//         if(!employeeIdString.contains(metacubeId)) {
//             Employee__c employee=new Employee__c(Name=name,Metacube_Employee_Id__c=metacubeId, Is_Active__c=true );
//             insert employee;
//         }
//      }

//     public static void insertCategory(String category){
//         List<Category__c> categoryList=[select Name from Category__c];
//         List<String> categoryNameList=new List<String>();
//         for(Category__c ct:categoryList){
//             categoryNameList.add(ct.Name);
//         }
//         if(!categoryNameList.contains(category)) {

//             Category__c newCategory=new Category__c(Name=category);
//             insert newCategory;
//         }
//      }

//      public static void insertSubCategory(String subCategory, String category ){
//         List<Sub_Category__c> subCategoryList=[select Name from Sub_Category__c];
//         List<String> subCategoryNameList=new List<String>();
//         for(Sub_Category__c ct:subCategoryList){
//             subCategoryNameList.add(ct.Name);
//         }
//         if(!subCategoryNameList.contains(subCategory)) {
//             Id catId=[select name from category__c where name like :category].get(0).id;
//             Sub_Category__c newSubCategory=new Sub_Category__c(Name=subCategory,category__c=catId);
//             insert newSubCategory;
//         }
//      }

//     public static void insertQuarter(String quarter){
//         List<Quarter__c> quarterList=[select Name from Quarter__c];
//         List<String> quarterNameList=new List<String>();
//         for(Quarter__c ct:quarterList){
//             quarterNameList.add(ct.Name);
//         }
//         if(!quarterNameList.contains(quarter)) {
//             Quarter__c newQuarter=new Quarter__c(Name=quarter);
//             insert newQuarter;
//         }
//      }

//     public static void insertSystem(String systems){
//         List<System__c> systemList=[select Name from System__c];
//         List<String> systemNameList=new List<String>();
//         for(System__c ct:systemList){
//             systemNameList.add(ct.Name);
//         }
//         if(!systemNameList.contains(systems)){
//             System__c newQuarter=new System__c(Name=systems);
//             insert newQuarter;
//         }
//      }


//     public static void insertReceivedFeedback(String name,String quarter,String systems,String rating , String description, String metacubeId,String category,String subCategory){

//         Id catId = [select name from Category__c where name like:category].get(0).Id;
//         Id subCatId = [select name from Sub_Category__c where name like:subCategory].get(0).Id;
//         Id sysId= [select name from system__c where name like:systems].get(0).Id;
//         Id empId = [select name from Employee__c where Metacube_Employee_Id__c like: metacubeId ].get(0).Id;
//         Id quarterID = [select name from Quarter__c where name like:quarter].get(0).Id;

//         Received_Feedback__c newFeedback = new Received_Feedback__c();
//         newFeedback.Rating__c=Integer.valueOf(rating);
//         newFeedback.Date__c=Date.today();
//         newFeedback.Description__c=description;
//         newFeedback.Category__c=catId;
//         newFeedback.Sub_Category__c=subCatId;
//         newFeedback.System__c=sysId;
//         newfeedback.Quarter__c=quarterID;
//         newFeedback.Employee__c=empId;
//         insert newfeedback;



//    }
//     @HttpGet
//     global static List<Received_Feedback__c> getFeedback() {
//         return [SELECT Id, Rating__c, description__c, Metacube_Employee_Id__c,Category__c,Sub_Category__c FROM Received_Feedback__c];
//     }


}