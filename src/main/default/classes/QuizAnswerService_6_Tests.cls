
@isTest
public class QuizAnswerService_6_Tests {
    // Test setup to create mock data
    @testSetup
    static void setup() {
        // Disable triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create Quiz_Question__c test record
        Quiz_Question__c question = new Quiz_Question__c(
            Correct_Answer__c = 'A',
            Answer_A__c = 'A',
            Answer_B__c = 'B',
            Answer_C__c = 'C',
            Answer_D__c = 'D'
        );
        insert question;

        // Create correct Quiz_Answer__c test records
        List<Quiz_Answer__c> correctAnswers = new List<Quiz_Answer__c> {
            new Quiz_Answer__c(Question__c = question.Id, Answer__c = 'A', Timestamp__c = Datetime.now().getTime() / 1000),
            new Quiz_Answer__c(Question__c = question.Id, Answer__c = 'A', Timestamp__c = Datetime.now().getTime() / 1000)
        };
        insert correctAnswers;

        // Create incorrect Quiz_Answer__c test record
        Quiz_Answer__c incorrectAnswer = new Quiz_Answer__c(Question__c = question.Id, Answer__c = 'B', Timestamp__c = Datetime.now().getTime() / 1000);
        insert incorrectAnswer;
    }

    // Test for happy path scenario
    @isTest
    static void testGetCorrectAnswers_HappyPath() {
        // Get the test question
        Quiz_Question__c question = [SELECT Id, Correct_Answer__c FROM Quiz_Question__c][0];
        
        // Prepare expected result
        List<Quiz_Answer__c> expectedCorrectAnswers = [SELECT Id FROM Quiz_Answer__c WHERE Answer__c = :question.Correct_Answer__c];
        
        // Call the method and assert the results
        QuizAnswerService service = new QuizAnswerService();
        List<Quiz_Answer__c> actualCorrectAnswers = service.getCorrectAnswers(question);
        System.assertEquals(expectedCorrectAnswers.size(), actualCorrectAnswers.size(), 'The number of correct answers does not match.');
        System.assertEquals(expectedCorrectAnswers[0].Id, actualCorrectAnswers[0].Id, 'The correct answers do not match.');
    }

    // Test for sad path scenario
    @isTest
    static void testGetCorrectAnswers_SadPath() {
        // Create a new question with no correct answers
        Quiz_Question__c question = new Quiz_Question__c(
            Correct_Answer__c = 'C',
            Answer_A__c = 'A',
            Answer_B__c = 'B',
            Answer_C__c = 'C',
            Answer_D__c = 'D'
        );
        insert question;

        // Call the method and assert the results
        QuizAnswerService service = new QuizAnswerService();
        List<Quiz_Answer__c> actualCorrectAnswers = service.getCorrectAnswers(question);
        System.assertEquals(0, actualCorrectAnswers.size(), 'No correct answers should be returned for a question without correct answers.');
    }

    // Test for exceptional scenario
    @isTest
    static void testGetCorrectAnswers_ExceptionalScenario() {
        // Call the method with null question and assert the results
        QuizAnswerService service = new QuizAnswerService();
        try {
            service.getCorrectAnswers(null);
            System.assert(false, 'An exception should be thrown when null is passed as a question.');
        } catch (NullPointerException e) {
            System.assertEquals('Attempt to de-reference a null object', e.getMessage(), 'Invalid exception message returned.');
        }
    }
}
