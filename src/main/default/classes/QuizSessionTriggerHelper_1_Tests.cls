
@isTest
private class QuizSessionTriggerHelper_1_Tests {

    private static final String PHASE_REGISTRATION = 'Registration';

    @testSetup
    static void makeTestData() {
        // Create test data for Quiz_Session__c
        Quiz_Session__c session = new Quiz_Session__c(
            Phase__c = 'OtherPhase' // Some phase other than Registration
        );
        insert session;

        // Assuming 'Quiz_Session__c' is the field that relates Quiz_Question__c to Quiz_Session__c
        Quiz_Question__c question = new Quiz_Question__c(
            Quiz_Session__c = session.Id
            // Set other necessary fields
        );
        insert question;
    }

    // Happy path test
    @isTest
    static void testPhaseChangeToRegistrationWithQuestions() {
        // Bypass necessary triggers
        // Assuming we have a TriggerHandler for Quiz_Session__c
        TriggerHandler.bypass('QuizSessionTriggerHandler');

        // Prepare data and simulate update
        Quiz_Session__c session = [SELECT Id, Phase__c FROM Quiz_Session__c LIMIT 1];
        // Assuming 'Quiz_Session__c' is the lookup field and we're querying it
        Quiz_Question__c question = [SELECT Id FROM Quiz_Question__c WHERE Quiz_Session__c = :session.Id LIMIT 1];

        session.Phase__c = PHASE_REGISTRATION;
        Map<Id, Quiz_Session__c> oldMap = new Map<Id, Quiz_Session__c>{ session.Id => session.clone() };

        Test.startTest();
        QuizSessionTriggerHelper.beforeUpdate(new List<Quiz_Session__c>{session}, oldMap);
        Test.stopTest();

        // Verify Current_Question__c is set to the first associated question
        Quiz_Session__c updatedSession = [SELECT Current_Question__c FROM Quiz_Session__c WHERE Id = :session.Id];
        System.assertEquals(question.Id, updatedSession.Current_Question__c, 'Current_Question__c should be set to the first question\'s Id');
    }

    // No associated questions test
    @isTest
    static void testPhaseChangeToRegistrationWithNoQuestions() {
        // Bypass necessary triggers
        // Assuming we have a TriggerHandler for Quiz_Session__c
        TriggerHandler.bypass('QuizSessionTriggerHandler');

        // Prepare data and simulate update
        Quiz_Session__c session = new Quiz_Session__c(Phase__c = 'OtherPhase');
        insert session;

        session.Phase__c = PHASE_REGISTRATION;
        Map<Id, Quiz_Session__c> oldMap = new Map<Id, Quiz_Session__c>{ session.Id => new Quiz_Session__c(Phase__c = 'OtherPhase') };

        Test.startTest();
        QuizSessionTriggerHelper.beforeUpdate(new List<Quiz_Session__c>{session}, oldMap);
        Test.stopTest();

        // Verify Current_Question__c is not set because there are no associated questions
        Quiz_Session__c updatedSession = [SELECT Current_Question__c FROM Quiz_Session__c WHERE Id = :session.Id];
        System.assert(updatedSession.Current_Question__c == null, 'Current_Question__c should be null as there are no questions');
    }

    // No phase change test
    @isTest
    static void testNoPhaseChange() {
        // Bypass necessary triggers
        // Assuming we have a TriggerHandler for Quiz_Session__c
        TriggerHandler.bypass('QuizSessionTriggerHandler');

        // Prepare data and simulate update
        Quiz_Session__c session = [SELECT Id, Phase__c FROM Quiz_Session__c LIMIT 1];
        Map<Id, Quiz_Session__c> oldMap = new Map<Id, Quiz_Session__c>{ session.Id => session.clone() };

        Test.startTest();
        QuizSessionTriggerHelper.beforeUpdate(new List<Quiz_Session__c>{session}, oldMap);
        Test.stopTest();

        // Verify that Current_Question__c is unchanged
        Quiz_Session__c updatedSession = [SELECT Current_Question__c FROM Quiz_Session__c WHERE Id = :session.Id];
        System.assertEquals(null, updatedSession.Current_Question__c, 'Current_Question__c should remain unchanged');
    }
}
