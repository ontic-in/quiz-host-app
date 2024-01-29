
@isTest
private class QuizAnswerService_5_Tests {

    @testSetup
    static void setupTestData() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Create test data for Quiz_Player__c
        Quiz_Player__c player1 = new Quiz_Player__c(Name = 'Test Player 1');
        insert player1;
        Quiz_Player__c player2 = new Quiz_Player__c(Name = 'Test Player 2');
        insert player2;

        // Assume Quiz_Question__c has a valid setup. Querying for two questions.
        List<Quiz_Question__c> questions = [SELECT Id FROM Quiz_Question__c LIMIT 2];

        // Create test data for Quiz_Answer__c
        if (questions.size() >= 2) {
            Quiz_Answer__c answer1 = new Quiz_Answer__c(
                Player__c = player1.Id, 
                Question__c = questions[0].Id, 
                Answer__c = 'A'
            );
            insert answer1;
            Quiz_Answer__c answer2 = new Quiz_Answer__c(
                Player__c = player2.Id, 
                Question__c = questions[1].Id, 
                Answer__c = 'B'
            );
            insert answer2;
        }

        // Clear bypasses for the trigger handlers
        TriggerHandler.clearBypass('AccountTriggerHandler');
        TriggerHandler.clearBypass('MDTAccountTriggerHandler');
    }
    
    @isTest
    static void testGetPlayerQuestionMappingWithResults() {
        // Retrieve test players
        List<Quiz_Player__c> testPlayers = [SELECT Id FROM Quiz_Player__c];
        Set<Id> playerIds = new Set<Id>();
        for (Quiz_Player__c player : testPlayers) {
            playerIds.add(player.Id);
        }

        Test.startTest();
        // Execute the method to test
        Map<Id, Id> result = new QuizAnswerService().getPlayerQuestionMapping(playerIds);
        Test.stopTest();

        // Assertions
        System.assertEquals(2, result.size(), 'There should be 2 entries in the result.');
        System.assertNotEquals(null, result.get(testPlayers[0].Id), 'The first player should have a question mapping.');
        System.assertNotEquals(null, result.get(testPlayers[1].Id), 'The second player should have a question mapping.');
    }
    
    @isTest
    static void testGetPlayerQuestionMappingWithEmptyInput() {
        Set<Id> playerIds = new Set<Id>();

        Test.startTest();
        // Execute the method to test with an empty set
        Map<Id, Id> result = new QuizAnswerService().getPlayerQuestionMapping(playerIds);
        Test.stopTest();

        // Assertions
        System.assertEquals(0, result.size(), 'Result should be empty when input set is empty.');
    }

    @isTest
    static void testGetPlayerQuestionMappingWithNoCorrespondingAnswers() {
        // Set up a player ID that does not have answers
        Set<Id> playerIds = new Set<Id>{'0123456789abcdefABC'};

        Test.startTest();
        // Execute the method to test with a non-existing player ID
        Map<Id, Id> result = new QuizAnswerService().getPlayerQuestionMapping(playerIds);
        Test.stopTest();

        // Assertions
        System.assertEquals(0, result.size(), 'Result should be empty when there are no corresponding answers.');
    }
}
