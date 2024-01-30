
@isTest
public class QuizAnswerService_8_Tests {
    
    static User createSysAdminUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        return u;
    }
    
    @testSetup
    static void setupTestData() {
        User sysAdmin = createSysAdminUser();
        System.runAs(sysAdmin) {
            // Create and insert test data
            // We are making sure all triggers are disabled
            TriggerHandler.bypass('MDTAccountTriggerHandler');
            TriggerHandler.bypass('AccountTriggerHandler');
            
            // Insert a test player
            Quiz_Player__c player = new Quiz_Player__c(Name='Test Player', Score__c=100.0, Ranking__c=1);
            insert player;
    
            // Insert a test question
            Quiz_Question__c question = new Quiz_Question__c(Correct_Answer__c='A', Answer_A__c='A', Answer_B__c='B', Answer_C__c='C', Answer_D__c='D');
            insert question;
    
            // Insert test answers
            List<Quiz_Answer__c> answers = new List<Quiz_Answer__c>();
            for(Integer i=0; i<5; i++) {
                answers.add(new Quiz_Answer__c(Player__c=player.Id, Question__c=question.Id, Score__c=20.0, 
                Answer__c=(Math.mod(i,2)==0) ? 'A' : 'B', IsCorrect__c=(Math.mod(i,2)==0)));
            }
            insert answers;
        }
    }

    @isTest
    static void testPlayerStats_HappyPath() {
        User sysAdmin = createSysAdminUser();
        System.runAs(sysAdmin) {
            // Get the test player
            Quiz_Player__c player = [SELECT Id, Score__c, Ranking__c, Name FROM Quiz_Player__c WHERE Name='Test Player'];
            
            // Call the method
            QuizAnswerService service = new QuizAnswerService();
            QuizAnswerService.PlayerStats stats = service.getPlayerAnswerStats(player.Id);
    
            // Test assertions
            System.assertEquals(2, stats.wrongCount);
            System.assertEquals(3, stats.correctCount);
        }
    }

    @isTest
    static void testPlayerStats_NoAnswers() {
        User sysAdmin = createSysAdminUser();
        System.runAs(sysAdmin) {
            // Insert a player with no answers
            TriggerHandler.bypass('MDTAccountTriggerHandler');
            TriggerHandler.bypass('AccountTriggerHandler');
            Quiz_Player__c playerNoAnswer = new Quiz_Player__c(Name='Test Player No Answer', Score__c=0.0, Ranking__c=1);
            insert playerNoAnswer;
    
            // Call the method
            QuizAnswerService service = new QuizAnswerService();
            QuizAnswerService.PlayerStats stats = service.getPlayerAnswerStats(playerNoAnswer.Id);
    
            // Test assertions
            System.assertEquals(0, stats.wrongCount);
            System.assertEquals(0, stats.correctCount);
        }
    }
}
