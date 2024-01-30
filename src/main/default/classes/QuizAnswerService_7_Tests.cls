
@isTest
public class QuizAnswerService_7_Tests {
    @testSetup static void setup() {
        // Test User setup
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        insert testUser;

        // Initial test data setup
        Quiz_Player__c testPlayer = new Quiz_Player__c(Name='Test Player');
        insert testPlayer;
        Quiz_Question__c testQuestion = new Quiz_Question__c(Correct_Answer__c='A', 
                                                            Answer_A__c='A', 
                                                            Answer_B__c='B', 
                                                            Answer_C__c='C', 
                                                            Answer_D__c='D');
        insert testQuestion;
        Quiz_Answer__c testAnswer = new Quiz_Answer__c(Player__c=testPlayer.Id, Question__c=testQuestion.Id, Answer__c='A');
        insert testAnswer;
    }
    
    @isTest static void testGetFromPlayer_HappyPath() {
        // Fetch test data
        Quiz_Player__c player = [SELECT Id FROM Quiz_Player__c WHERE Name='Test Player'];
        Quiz_Question__c question = [SELECT Id FROM Quiz_Question__c WHERE Correct_Answer__c='A'];
        User testUser = [SELECT Id FROM User WHERE Email='standarduser@testorg.com'];

        System.runAs(testUser) {
            Test.startTest();

            // Bypass Triggers
            TriggerHandler.bypass('QuizAnswerService');

            QuizAnswerService quizAnswerService = new QuizAnswerService();
            Quiz_Answer__c fetchedAnswer = quizAnswerService.getFromPlayer(player.Id, question.Id);

            Test.stopTest();
            
            // Assertions
            System.assertNotEquals(null, fetchedAnswer, 'Fetched answer should not be null');
            System.assertEquals('A', fetchedAnswer.Answer__c, 'Fetched answer should be correct');
        }
    }
    
    @isTest static void testGetFromPlayer_SadPath() {
        // Fetch test data
        Quiz_Player__c player = [SELECT Id FROM Quiz_Player__c WHERE Name='Test Player'];
        Quiz_Question__c question = [SELECT Id FROM Quiz_Question__c WHERE Correct_Answer__c='A'];
        User testUser = [SELECT Id FROM User WHERE Email='standarduser@testorg.com'];

        System.runAs(testUser) {
            Test.startTest();

            // Bypass Triggers
            TriggerHandler.bypass('QuizAnswerService');
            
            QuizAnswerService quizAnswerService = new QuizAnswerService();
            // Changing the question ID to a non-existing one
            Boolean isExceptionThrown = false;
            try {
                Quiz_Answer__c fetchedAnswer = quizAnswerService.getFromPlayer(player.Id, question.Id + '123');
            } catch(Exception e) {
                isExceptionThrown = true;
            }
            
            Test.stopTest();
            
            // Assertions
            System.assertEquals(true, isExceptionThrown, 'Exception should have been thrown');
        }
    }
}
