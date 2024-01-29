
@isTest
private class QuizAnswerService_4_Tests {
    @testSetup
    static void setup() {
        // Create test data for Quiz_Answer__c records
        List<Quiz_Answer__c> quizAnswers = new List<Quiz_Answer__c>();

        // Create test players
        Account player1 = new Account(Name='Test Player 1');
        insert player1;
        Account player2 = new Account(Name='Test Player 2');
        insert player2;

        // Create Quiz_Answer__c records
        quizAnswers.add(new Quiz_Answer__c(Player__c = player1.Id));
        quizAnswers.add(new Quiz_Answer__c(Player__c = player1.Id));
        quizAnswers.add(new Quiz_Answer__c(Player__c = player2.Id));

        insert quizAnswers;
    }

    @isTest
    static void testGetUniquePlayerIdsWithMultipleRecords() {
        List<Quiz_Answer__c> answers = [SELECT Player__c FROM Quiz_Answer__c];
        Set<Id> expectedPlayerIds = new Set<Id>{answers[0].Player__c, answers[2].Player__c};
        QuizAnswerService service = new QuizAnswerService();

        Test.startTest();
        Set<Id> uniquePlayerIds = service.getUniquePlayerIds(answers);
        Test.stopTest();

        System.assertEquals(2, uniquePlayerIds.size(), 'Should have 2 unique player Ids');
        System.assertEquals(expectedPlayerIds, uniquePlayerIds, 'The player Ids should match the expected set');
    }

    @isTest
    static void testGetUniquePlayerIdsWithEmptyList() {
        List<Quiz_Answer__c> answers = new List<Quiz_Answer__c>();
        QuizAnswerService service = new QuizAnswerService();

        Test.startTest();
        Set<Id> uniquePlayerIds = service.getUniquePlayerIds(answers);
        Test.stopTest();

        System.assertEquals(0, uniquePlayerIds.size(), 'Should return an empty set for an empty list');
    }

    @isTest
    static void testGetUniquePlayerIdsWithNull() {
        QuizAnswerService service = new QuizAnswerService();

        Test.startTest();
        Set<Id> uniquePlayerIds = service.getUniquePlayerIds(null);
        Test.stopTest();

        System.assertEquals(new Set<Id>(), uniquePlayerIds, 'The returned set should be an empty set when null is passed as parameter.');
    }

    @isTest
    static void testGetUniquePlayerIdsWithSingleEntry() {
        List<Quiz_Answer__c> answers = [SELECT Player__c FROM Quiz_Answer__c LIMIT 1];
        Set<Id> expectedPlayerIds = new Set<Id>{answers[0].Player__c};
        QuizAnswerService service = new QuizAnswerService();

        Test.startTest();
        Set<Id> uniquePlayerIds = service.getUniquePlayerIds(answers);
        Test.stopTest();

        System.assertEquals(1, uniquePlayerIds.size(), 'Should return a set with a single Id');
        System.assertEquals(expectedPlayerIds, uniquePlayerIds, 'The player Ids should match the expected set');
    }
}
