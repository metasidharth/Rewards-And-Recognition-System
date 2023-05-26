public class MasterClassforLeaderboard {
    
    
    @AuraEnabled(cacheable=true)
    public static List<Quarter__c> fetchQaurter(){
        
        SelectorForQuarter quarter = new SelectorForQuarter();
        List<Quarter__c> quarterList = quarter.getQuarter();
        
	    system.debug('Quarter List is '+quarterList);
      return quarterList;
        //return [select name from quarter__c];
		        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Category__c> fetchCategory(){
        //List<Category__c> categoryList= new List<Category__c>();
        //categoryList=[Select name from Category__c];
        //system.debug(categoryList);
        
        SelectorForCategory category= new SelectorForCategory();
        List<Category__c> categoryList = category.getCategory();
       system.debug('Category List is '+categoryList);

        return categoryList;
    }
    
     @AuraEnabled(cacheable=true)
    public static List<Sub_Category__c> fetchSubCategory(String categoryValue){
        //List<SubCategory__c> subcategoryList = new List<SubCategory__c>();
        //subcategoryList = [Select Name from SubCategory__c where Category__r.name like: categoryValue];   
        //system.debug('The list is ' + subcategoryList);
        
        SelectorForSubCategory subCategory = new SelectorForSubCategory();
        List<Sub_Category__c> subcategoryList = subCategory.getSubCategory(categoryValue);
        system.debug('Sub Category List is '+subcategoryList);
        return subcategoryList;
        
    }

   
    
    @AuraEnabled(cacheable=true)
    public static List<Feedback__c> getData(String categoryValue,String subCategoryValue,String quarterValue){
        
        //return [select MetacubeEmployeeId__c,points__c , description__c , category__c
          //     ,subCategory__c ,quarter__c from ReceivedFeedback__c where 
            //    Quarter__c like:quarterValue and 
              //  Category__c like:categoryValue and
                //subCategory__c like:subCategoryValue 
                //order by Points__c DESC limit 10
               //];/
        
        SelectorForLeaderboard leaderboard = new SelectorForLeaderboard();
        List<Feedback__c> leaderboardList = leaderboard.getLeaderboard(categoryValue,subCategoryValue,quarterValue);
        system.debug('Leaderboard List is '+ leaderboardList);
        return leaderboardList;
    }
    
}