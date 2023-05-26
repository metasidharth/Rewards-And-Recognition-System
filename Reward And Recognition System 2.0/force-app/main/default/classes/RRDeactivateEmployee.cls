@RestResource(urlMapping='/DeactivateEmployee/')
global class RRDeactivateEmployee {
    
     @HttpPost
    global static String DeactivateEmployee(List<EmployeeDetails> data){
        List<Employee__c> updateEmployeeList=new List<Employee__c>();
        Map<String,Employee__c>employeeMap=new Map<String,Employee__c>();
        
        SelectorForEmployeeAPI empList=new SelectorForEmployeeAPI();
        
         for(Employee__c emp: empList.getEmployee() ){
            employeeMap.put(emp.Employee_Id__c,emp);
        }
        
        //for(Employee__c emp:[select Employee_Id__c,Is_Active__c,First_Name__c,Last_Name__c from Employee__c]){
          //  employeeMap.put(emp.Employee_Id__c,emp);
        //}
        for(EmployeeDetails employee:data){
            if(employeeMap.keySet().contains(employee.employeeId)){
                employee__c updateEmployee=employeeMap.get(employee.employeeId);
                //if(employee.status.toLowerCase()!='active')
                updateEmployee.Is_Active__c=false;
                updateEmployeeList.add(updateEmployee);
            }
        }
        update(updateEmployeeList);  
        return 'Success';   
    }
    
    global class EmployeeDetails{
        public String employeeId {get;set;}
    }
}