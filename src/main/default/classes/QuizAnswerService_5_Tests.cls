
@isTest
public class QuizAnswerService_5_Tests {

    @testSetup
    static void setupTestData() {
        // Create test data
        Quiz_Player__c player = new Quiz_Player__c(Name='Test Player');
        insert player;
        
        Quiz_Question__c question = new Quiz_Question__c(
            Answer_A__c='A', 
            Answer_B__c='B', 
            Answer_C__c='C', 
            Answer_D__c='D', 
            Correct_Answer__c='A'
        );
        insert question;
        
        TriggerHandler.bypass('QuizAnswerTriggerHandler');
        Quiz_Answer__c answer = new Quiz_Answer__c(Player__c = player.Id, Question__c = question.Id, Answer__c = 'A');
        insert answer;
        TriggerHandler.clearBypass('QuizAnswerTriggerHandler');
    }

    @isTest
    static void testGetPlayerQuestionMapping_HappyPath() {
        QuizAnswerService answerService = new QuizAnswerService();
        Quiz_Player__c player = [SELECT Id FROM Quiz_Player__c WHERE Name = 'Test Player' LIMIT 1];
        Set<Id> playerIds = new Set<Id> {player.Id};
        
        Map<Id, Id> result = answerService.getPlayerQuestionMapping(playerIds);
        
        System.assertEquals(1, result.size(), 'The Map should have one entry');
        System.assertEquals(player.Id, result.keySet().iterator().next(), 'The Map should contain the player Id');
    }

    @isTest
    static void testGetPlayerQuestionMapping_SadPath() {
        QuizAnswerService answerService = new QuizAnswerService();
        Set<Id> playerIds = new Set<Id> {}; //Empty set of player Ids
        
        Map<Id, Id> result = answerService.getPlayerQuestionMapping(playerIds);
        
        System.assertEquals(0, result.size(), 'The Map should be empty for no player Ids');
    }
}
