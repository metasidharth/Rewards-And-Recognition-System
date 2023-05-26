public class LeaderboardEmailScheduler implements Schedulable {
    
    public void execute(SchedulableContext ctx) {
        // Query the top 10 sales reps for the current month
	List<AggregateResult> results = [SELECT Employee__r.Name, Employee__r.Employee_Id__c, SUM(Points__c) 
                                 FROM Feedback__c
                                 GROUP BY Employee__r.Name, Employee__r.Employee_Id__c
                                 ORDER BY SUM(Points__c) DESC
                                 LIMIT 10];

    
    //SelectorForEmailSchedular leaderboard = new SelectorForEmailSchedular();
    //List<AggregateResult> results = leaderboard.getEmailSchedularFields();
    //return results;

        List<Employee__c> emailList=[select Email__c from Employee__c];
        List<String> emailListString = new List<String>();
        
        for(Employee__c emp:emailList){
            if(emp.Email__c != NULL) {
            emailListString.add(String.valueOf(emp.Email__c));
            }
        }
        
        System.debug('Email List is '+ emailListString);
            
        
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
        email.setToAddresses(emailListString);
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
        htmlBody += '</tr></thead><tbody>';
        
        // Add rows for each result
        Integer rank = 1;
        for (AggregateResult result : results) {
            String rowStyle = oddRowStyle;
            if (Math.mod(rank, 2) == 0) {
                rowStyle = evenRowStyle;
            }
            htmlBody += '<tr style="' + rowStyle + '">';
            htmlBody += '<td style="' + cellStyle + '">' + rank + '</td>';
            htmlBody += '<td style="' + cellStyle + '">' + result.get('Name') + '</td>';
            htmlBody += '<td style="' + cellStyle + '">' + result.get('Employee_Id__c') + '</td>';
            htmlBody += '<td style="' + cellStyle + '">' + result.get('expr0') + '</td>';
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
    }
    
//LeaderboardEmailScheduler instance=new LeaderboardEmailScheduler();
//String cron = '00 45 14 13 4 ? 2023';
//String jobId=System.schedule('Leaderboard Email Scheduler', cron, new LeaderboardEmailScheduler());
//system.debug(jobId);

}