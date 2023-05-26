@RestResource(urlMapping='/GetBadgePointsDetails/')
global class RRGetBadgeDetailsAPI {

    @HttpGet
    global static List<EmployeeBadgeDetails> getBadge() {
        
        List<EmployeeBadgeDetails> getApiList=new List<EmployeeBadgeDetails>();
      List<Employee_Badge__c> employeeBadgeList=[SELECT Total_Points__c, Category__r.name,Employee__r.name ,Employee__r.Employee_Id__c,
                Assigned_Badge__r.title__c, Assigned_Badge__r.Image__c
                from Employee_Badge__c];
        
        for(Employee_Badge__c emp:employeeBadgeList){
           EmployeeBadgeDetails wrapperObj=new  EmployeeBadgeDetails();
			wrapperObj.category=emp.Category__r.name;
            wrapperObj.totalPoints=emp.Total_Points__c;
            wrapperObj.badgeTitle= emp.Assigned_Badge__r.title__c;
            wrapperObj.employeeId=emp.Employee__r.Employee_Id__c;
            wrapperObj.badgeImage=emp.Assigned_Badge__r.Image__c;
            wrapperObj.employeeName=emp.Employee__r.name;
            getApiList.add(wrapperObj);
        }
        return getApiList;
    }
    
    
    global class EmployeeBadgeDetails{  
        public String category { get; set; }
        public String badgeImage { get; set; }
        public String employeeId { get; set; }
        public String employeeName{get;set;}
        public String badgeTitle{get ;set;}
        public Decimal totalPoints{get;set;}
    }
}