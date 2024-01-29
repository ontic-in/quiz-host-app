
@isTest
public class QuizSessionTriggerHelper_2_Tests {

    @testSetup
    static void setup() {
        // Create test data for Quiz_Session__c
        Quiz_Session__c quizSession = new Quiz_Session__c(
            Phase__c = 'Registration' // Use actual phase enumeration if exists
        );
        // Insert other necessary test data here
        insert quizSession;
    }

    @isTest
    static void testAfterUpdateToQuestionResults() {
        // Set up and mock test data
        // ...

        Test.startTest();
        // Call the method to test
        QuizSessionTriggerHelper.afterUpdate(updatedSessions, oldMap);
        Test.stopTest();

        // Perform assertions to verify expected behavior
        // ...
    }

    @isTest
    static void testAfterUpdateToRegistration() {
        Quiz_Session__c testSession = [SELECT Phase__c FROM Quiz_Session__c LIMIT 1];
        testSession.Phase__c = 'QuestionResults'; // Simulate phase change
        Map<Id, Quiz_Session__c> oldMap = new Map<Id, Quiz_Session__c>{
            testSession.Id => testSession.clone()
        };
        List<Quiz_Session__c> updatedSessions = new List<Quiz_Session__c>{testSession};

        // Assuming the deleteAnswersAndPlayers method would reduce the record count
        // of related records, we fetch the count before the update.
        Integer relatedRecordsCountBefore = [SELECT Count() FROM Related_Record__c WHERE Quiz_Session__c = :testSession.Id];

        Test.startTest();
        QuizSessionTriggerHelper.afterUpdate(updatedSessions, oldMap);
        Test.stopTest();

        // Fetch the updated count of related records
        Integer relatedRecordsCountAfter = [SELECT Count() FROM Related_Record__c WHERE Quiz_Session__c = :testSession.Id];
        
        // Assert that related records have been deleted
        System.assert(relatedRecordsCountBefore > relatedRecordsCountAfter, 'Related records should be deleted when phase changes to Registration');
    }

    @isTest
    static void testNoPhaseChange() {
        // Set up and mock test data
        // ...

        Test.startTest();
        // Call the method to test
        QuizSessionTriggerHelper.afterUpdate(updatedSessions, oldMap);
        Test.stopTest();

        // Perform assertions to verify that no changes have been made
        // ...
    }

    // You can include other test methods to cover additional scenarios
}
