
@isTest
private class QuizAnswerService_3_Tests {

    @testSetup
    static void setup() {
        // Create test records and configurations as necessary
        Quiz_Session__c session = new Quiz_Session__c(Phase__c = 'Question', Current_Question__c = 'dummyQuestionId');
        insert session;
    }
    
    @isTest
    static void testCreateAnswerHappyPath() {
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        QuizAnswerService answerService = new QuizAnswerService();
        Id playerId = 'dummyPlayerId'; // Normally we would create a player record and use its ID
        
        // Act
        Quiz_Answer__c result = answerService.create(playerId, 'A');
        
        // Assert
        System.assertNotEquals(null, result, 'The answer record should not be null.');
        System.assertEquals(playerId, result.Player__c, 'The player ID should match the input.');
    }
    
    @isTest
    static void testCreateAnswerInvalidPhase() {
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Update session to a non-Question phase for this test
        Quiz_Session__c session = [SELECT Id FROM Quiz_Session__c LIMIT 1];
        session.Phase__c = 'NonQuestion';
        update session;
        
        QuizAnswerService answerService = new QuizAnswerService();
        Id playerId = 'dummyPlayerId';
        
        // Act and Assert
        try {
            answerService.create(playerId, 'A');
            System.assert(false, 'Exception should have been thrown due to invalid phase.');
        } catch (QuizAnswerService.InvalidPhaseException e) {
            System.assert(true, 'InvalidPhaseException was correctly thrown.');
        }
    }
    
    @isTest
    static void testCreateAnswerDuplicate() {
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        QuizAnswerService answerService = new QuizAnswerService();
        Id playerId = 'dummyPlayerId';
        String answer = 'A';
        Id questionId = 'dummyQuestionId';
        
        // Insert a dummy answer to enforce duplicate test
        Quiz_Answer__c existingAnswer = new Quiz_Answer__c(Player__c = playerId, Question__c = questionId, Answer__c = answer);
        insert existingAnswer;
        
        // Act and Assert
        try {
            answerService.create(playerId, answer);
            System.assert(false, 'Exception should have been thrown due to duplicate answer.');
        } catch (QuizAnswerService.DuplicateAnswerException e) {
            System.assert(true, 'DuplicateAnswerException was correctly thrown.');
        }
    }

    // Additional tests for other exceptional scenarios could be included as well.
}
