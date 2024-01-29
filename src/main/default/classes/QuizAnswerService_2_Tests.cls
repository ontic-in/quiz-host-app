
@isTest
private class QuizAnswerService_2_Tests {

    @testSetup
    static void makeTestData() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Quiz_Session__c session = new Quiz_Session__c(Current_Question__c = 'a0X1N00000CaxUxUAJ'); // Replace with a valid Id format in your org
        insert session;

        Quiz_Question__c question = new Quiz_Question__c(Id = session.Id, Correct_Answer__c = 'A');
        insert question;

        List<Quiz_Answer__c> answers = new List<Quiz_Answer__c>{
            new Quiz_Answer__c(Question__c = session.Id, Answer__c = 'A'),
            new Quiz_Answer__c(Question__c = session.Id, Answer__c = 'B'),
            new Quiz_Answer__c(Question__c = session.Id, Answer__c = 'C'),
            new Quiz_Answer__c(Question__c = session.Id, Answer__c = 'D'),
            new Quiz_Answer__c(Question__c = session.Id, Answer__c = 'A')
        };
        insert answers;
    }

    @isTest
    static void testGetAnswerStatsHappyPath() {
        Test.startTest();
        QuizAnswerService service = new QuizAnswerService();
        Map<String, Integer> result = service.getAnswerStats();
        Test.stopTest();

        System.assertEquals(2, result.get('A'), 'There should be 2 A answers.');
        System.assertEquals(1, result.get('B'), 'There should be 1 B answer.');
        System.assertEquals(1, result.get('C'), 'There should be 1 C answer.');
        System.assertEquals(1, result.get('D'), 'There should be 1 D answer.');
    }

    @isTest
    static void testGetAnswerStatsNoCurrentQuestion() {
        Quiz_Session__c session = [SELECT Id, Current_Question__c FROM Quiz_Session__c LIMIT 1];
        session.Current_Question__c = null;
        update session;

        Test.startTest();
        QuizAnswerService service = new QuizAnswerService();
        Map<String, Integer> result = service.getAnswerStats();
        Test.stopTest();

        for (String key : result.keySet()) {
            System.assertEquals(0, result.get(key), 'The count for ' + key + ' should be 0.');
        }
    }

    @isTest
    static void testGetAnswerStatsNoSession() {
        delete [SELECT Id FROM Quiz_Session__c];

        Test.startTest();
        QuizAnswerService service = new QuizAnswerService();
        try {
            service.getAnswerStats();
            System.assert(false, 'Method did not throw an exception when there is no quiz session.');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('No active quiz session'), 'The message should indicate no active quiz session.');
        }
        Test.stopTest();
    }
}
