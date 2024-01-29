
@isTest
private class QuizAnswerService_6_Tests {

    @testSetup
    static void setup() {
        // Create test data for Quiz_Question__c and Quiz_Answer__c
        Quiz_Question__c testQuestion = new Quiz_Question__c(
            Name = 'Test Question',
            Correct_Answer__c = 'A'
        );
        insert testQuestion;

        List<Quiz_Answer__c> answerList = new List<Quiz_Answer__c>{
            new Quiz_Answer__c(
                Question__c = testQuestion.Id,
                Answer__c = 'A', // Correct answer
                IsCorrect__c = true
            ),
            new Quiz_Answer__c(
                Question__c = testQuestion.Id,
                Answer__c = 'B', // Incorrect answer
                IsCorrect__c = false
            )
        };
        insert answerList;
    }

    @isTest
    static void testGetCorrectAnswersWithResults() {
        // Query the test question
        Quiz_Question__c testQuestion = [SELECT Id, Correct_Answer__c FROM Quiz_Question__c LIMIT 1];

        // Test getCorrectAnswers method
        Test.startTest();
        List<Quiz_Answer__c> correctAnswers = new QuizAnswerService().getCorrectAnswers(testQuestion);
        Test.stopTest();

        // Assert that the correct answers are returned
        System.assertEquals(1, correctAnswers.size(), 'Should retrieve one correct answer.');
        System.assertEquals('A', correctAnswers[0].Answer__c, 'The answer should match the correct answer.');
    }

    @isTest
    static void testGetCorrectAnswersNoResults() {
        // Create a question with no correct answers
        Quiz_Question__c testQuestion = new Quiz_Question__c(
            Name = 'Unanswered Question',
            Correct_Answer__c = 'Z' // No such answer provided
        );
        insert testQuestion;

        // Test getCorrectAnswers method
        Test.startTest();
        List<Quiz_Answer__c> correctAnswers = new QuizAnswerService().getCorrectAnswers(testQuestion);
        Test.stopTest();

        // Assert that no answers are returned for the new question
        System.assertEquals(0, correctAnswers.size(), 'Should retrieve no answers.');
    }

    @isTest
    static void testGetCorrectAnswersWithNullException() {
        try {
            // Attempt to call the method with a null parameter
            Test.startTest();
            new QuizAnswerService().getCorrectAnswers(null);
            Test.stopTest();
            System.assert(false, 'The method did not throw an exception as expected.');
        } catch (NullPointerException e) {
            // Expected exception was thrown, test passes
            System.assert(true);
        }
    }
}
