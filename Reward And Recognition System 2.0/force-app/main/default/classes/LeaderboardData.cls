public class LeaderboardData {
    
    @AuraEnabled(Cacheable=true)
    public static List<Category__c> getCategory(){
        /*
        List<Category__c> catList=[select Name from Category__c];
       */
        List<Category__c> catList=new List<Category__c>();
        SelectorForCategory CategorySelector=new SelectorForCategory();
        catList=CategorySelector.getCategory();
        return catList;
    }
    
    @AuraEnabled(Cacheable=true)
    public static List<Sub_Category__c> getSubCategory(String categoryValue){
        /*
        List<Sub_Category__c> subCatList=[select Name from Sub_Category__c where Category__r.Name like:categoryValue];
		*/
        SelectorForSubCategory SubCategorySelector=new SelectorForSubCategory();
        List<Sub_Category__c> subCatList=subCategorySelector.getSubCategory(categoryValue);
        return subCatList;
    }
    
    @AuraEnabled(Cacheable=true)
    public static List<Quarter__c> getQuarter(){
        /*
        List<Quarter__c> quarterList=[select Name from Quarter__c ];
       */
        SelectorForQuarter quarterSelector=new SelectorForQuarter();
        List<Quarter__c> quarterList=quarterSelector.getQuarter();
        return quarterList;
    }
    
    @AuraEnabled(Cacheable=true)
    public static List<Feedback__c> getLeaderboard(String categoryValue,String subCategoryValue,String quarterValue){
        /*
        List<Feedback__c> leaderboardList=[SELECT Employee__r.Name, Employee__r.Employee_Id__c,Quarter__r.Name, Points__c, System_Configuration__r.Category__r.Name, System_Configuration__r.Sub_Category__r.Name 
                                           FROM Feedback__c 
                                           WHERE System_Configuration__r.Category__r.Name LIKE :categoryValue 
                                           AND System_Configuration__r.Sub_Category__r.Name LIKE :subCategoryValue 
                                           AND Quarter__r.Name LIKE :quarterValue order by Points__c desc limit 10 
                                          ];
	*/
        SelectorForFeedback  feedbackSelector= new SelectorForFeedback();
        List<feedback__c>leaderboardList=feedbackSelector.getFeedback(categoryValue, subCategoryValue, quarterValue);
        system.debug(leaderboardList);
        return leaderboardList;             
        
    }
    @AuraEnabled(Cacheable=true)
    public static List<String> sendEmailToAllEmployees(String leaderboardArrayJSON){
        /*
        List<Employee__c> employeeList=[select Name,Email__c from Employee__c limit 10];
        */
        SelectorForEmployee employeeSelector=new SelectorForEmployee();
        List<Employee__c> employeeList=employeeSelector.getEmployee();
       List<Employee__c> empList=new List<Employee__c>();
        //for 10 employees because of email exception Exceed Email List in apex 
        if(EmployeeList.size()>10){
            for(Integer i=0;i<10;i++){
                emplist.add(EmployeeList[i]);
            }
        }
        else{
            empList.addAll(EmployeeList);
        }
        List<String> emailList=new List<String> ();
        for (Employee__c fb:empList  ){
            if(fb.Email__c!=null){
            emailList.add(fb.Email__c);
            }
        }
        System.debug('the email list is '+emailList);
        sendEmailController(leaderboardArrayJSON,emailList);
        return emailList;
    }
    
    
    @AuraEnabled(Cacheable=true)
    public static List<String> sendEmailToEmployees(String leaderboardArrayJSON,String emailListJSON){
        List<Object>emailObj = (List<Object>)JSON.deserializeUntyped(emailListJSON);
        List<String> emailList=new List<String>();
        
        for(Object em:emailObj){
            emailList.add((String)em);
        }
        
        System.debug('the email list is '+emailList);
      sendEmailController(leaderboardArrayJSON,emailList);
        return emailList;
    }
    
    
    @AuraEnabled(Cacheable=true)
    public static List< String >sendEmailController(String leaderboardArrayJSON,List<String> emailList){
        //System.debug('leaderBoardArrayJSON: ' + leaderBoardArrayJSON);
       // List<String> emailList=new List<String>(emailListOfEmployee(category));
       
        List<Object> leaderBoardArray = (List<Object>) JSON.deserializeUntyped(leaderBoardArrayJSON);
        // System.debug(leaderBoardArray);
        
                Date today = Date.today();
        Integer currentMonth = today.month();
        Integer previousMonth = currentMonth - 1;
        
        // Handle the case where the previous month is December
        if (previousMonth == 0) {
            previousMonth = 12;
        }
        
        Date previousMonthDate = Date.newInstance(today.year(), previousMonth, today.day());
        
        // Use the Datetime class to format the date into a string in the "Month Year" format
        Datetime previousMonthDatetime = Datetime.newInstance(previousMonthDate.year(), previousMonthDate.month(), previousMonthDate.day());
        String previousMonthString = previousMonthDatetime.format('MMMM yyyy');
        
        System.debug('Today: ' + today);
        System.debug('Previous Month String: ' + previousMonthString);
        
        // Generate the email body using an email template
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId('00X2w000000WqF9');
        email.setToAddresses(emailList);
        email.setSubject('Top 10 Employees for ' + previousMonthString);
        email.setTargetObjectId(UserInfo.getUserId());
        email.setSaveAsActivity(false);
        email.setPlainTextBody('');
    
        
        // Generate the HTML email body
        String htmlBody = 'Dear All,<br/><br/>';
        
        htmlBody += 'This is the leaderboard for ' + previousMonthString + '<br/><br/>';
        
        // Define CSS styles for the table
        String tableStyle = 'border-collapse: collapse; width: 100%;';
        String headerRowStyle = 'background-color: #0070c0; color: white; font-weight: bold; text-align: center;';
        String cellStyle = 'border: 1px solid #dddddd; padding: 8px;';
        String oddRowStyle = 'background-color: #f2f2f2;';
        String evenRowStyle = 'background-color: #ffffff;';
        
        // Build the table HTML with the CSS styles
        htmlBody += '<table style="' + tableStyle + '">';
        htmlBody += '<thead><tr style="' + headerRowStyle + '">';
        htmlBody += '<th style="' + cellStyle + '">Rank</th>';
        htmlBody += '<th style="' + cellStyle + '">Employee Name</th>';
        htmlBody += '<th style="' + cellStyle + '">Employee Id</th>';
        htmlBody += '<th style="' + cellStyle + '">Total Points</th>';
         htmlBody += '<th style="' + cellStyle + '">Category</th>';
         htmlBody += '<th style="' + cellStyle + '">SubCategory</th>';
        htmlBody += '</tr></thead><tbody>';
         
         
        Integer rank = 1;
        for (Object result : leaderBoardArray) {
            System.debug('the result is '+result);
            String employeeId = (String) ((Map<String,Object>)result).get('Employee__r.Employee_Id__c');
            String employeeName = (String) ((Map<String,Object>)result).get('Employee__r.Name');
            Integer points = (Integer) ((Map<String,Object>)result).get('Points__c');
            String quarterName = (String) ((Map<String,Object>)result).get('Quarter__r.Name');
            String categoryName = (String) ((Map<String,Object>)result).get('System_Configuration__r.Category__r.Name');
            String subCategoryName = (String) ((Map<String,Object>)result).get('System_Configuration__r.Sub_Category__r.Name');
            System.debug('Employee Id: ' + employeeId);
            System.debug('Employee Name: ' + employeeName);
            System.debug('Points: ' + points);
            System.debug('Quarter Name: ' + quarterName);
            System.debug('Category Name: ' + categoryName);
            System.debug('Sub-Category Name: ' + subCategoryName);
            
             String rowStyle = oddRowStyle;
            if (Math.mod(rank, 2) == 0) {
                rowStyle = evenRowStyle;
            }
            htmlBody += '<tr style="' + rowStyle + '">';
            htmlBody += '<td style="' + cellStyle + '">' + rank + '</td>';
            htmlBody += '<td style="' + cellStyle + '">' + employeeName + '</td>';
            htmlBody += '<td style="' + cellStyle + '">' + employeeId + '</td>';
            htmlBody += '<td style="' + cellStyle + '">' + points + '</td>';
            htmlBody += '<td style="' + cellStyle + '">' + categoryName + '</td>';
            htmlBody += '<td style="' + cellStyle + '">' + subCategoryName + '</td>';
            htmlBody += '</tr>';
            rank++;
            
        }
        
        htmlBody += '</tbody></table><br/><br/>';
        htmlBody += 'A heartfelt congratulations for making it to the top 10 of the leaderboard, we appreciate your persistence and hard work!! 👏 <br/><br/>';
        htmlBody += 'Thanks & Regards,<br/><br/>';
        htmlBody += '<Sender Name>';
        htmlBody += '<h2 style="color: #3da8ef;">Metacube Software Pvt. Ltd.</h2>';
        htmlBody += 'SP-6, Phase IV, EPIP Sitapura, Jaipur, Rajasthan';

        
        // Set the HTML body for the email
        email.setHtmlBody(htmlBody);


        
        // Send the email
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        return emailList; 
    }
    
}




// @AuraEnabled(Cacheable=true)
//  public static String sendEmail(String leaderBoardArrayJSON){
//  List<Object> leaderBoardArray = (List<Object>) JSON.deserializeUntyped(leaderBoardArrayJSON);
//  List<String> emailList=new List<String>();
// for(leaderBoardArray)
//  System.debug('the leaderboard array is '+leaderBoardArray);
// return leaderBoardArrayJSON;
// }