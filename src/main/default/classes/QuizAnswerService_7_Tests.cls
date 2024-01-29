
@isTest
private class QuizAnswerService_7_Tests {

    @testSetup
    static void setupTestData() {
        // Assuming there are no required custom fields for Quiz_Player__c
        Quiz_Player__c player = new Quiz_Player__c();
        insert player;

        // Assuming there are no required custom fields for Quiz_Question__c
        Quiz_Question__c question = new Quiz_Question__c();
        insert question;

        Quiz_Answer__c answer = new Quiz_Answer__c(
            Player__c = player.Id,
            Question__c = question.Id,
            Answer__c = 'A' // Assuming 'A' is a valid value for the Answer__c field
        );
        insert answer;

        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    @isTest
    static void testGetFromPlayerWithExistingRecord() {
        // Query test data
        Quiz_Player__c player = [SELECT Id FROM Quiz_Player__c LIMIT 1];
        Quiz_Question__c question = [SELECT Id FROM Quiz_Question__c LIMIT 1];

        Test.startTest();
        QuizAnswerService service = new QuizAnswerService();
        Quiz_Answer__c result = service.getFromPlayer(player.Id, question.Id);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(player.Id, result.Player__c, 'The result should have the correct player ID.');
    }

    @isTest
    static void testGetFromPlayerWithNonExistingRecord() {
        // Obtain IDs of previously created test data, but pass a non-existing question ID
        Quiz_Player__c player = [SELECT Id FROM Quiz_Player__c LIMIT 1];
        Id fakeQuestionId = Schema.SObjectType.Quiz_Question__c.getKeyPrefix() + 'FAKE';

        Test.startTest();
        QuizAnswerService service = new QuizAnswerService();
        Quiz_Answer__c result = service.getFromPlayer(player.Id, fakeQuestionId);
        Test.stopTest();

        // Assertions
        System.assertEquals(null, result, 'The result should be null for a non-existing record.');
    }

    @isTest
    static void testGetFromPlayerWithNullParameters() {
        Boolean didThrowException = false;
        try {
            Test.startTest();
            QuizAnswerService service = new QuizAnswerService();
            service.getFromPlayer(null, null);
            Test.stopTest();
        } catch (Exception e) {
            // We are catching a generic exception because the actual exception type may vary
            didThrowException = true;
        }

        // Assertions
        System.assert(didThrowException, 'An exception should be thrown for null parameters.');
    }
}
