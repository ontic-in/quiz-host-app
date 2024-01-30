
@isTest
public class QuizAnswerService_2_Tests {
    private static Id questionId;
    private static Id sessionId;
    private static Id playerId;

    @testSetup
    static void setup() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Quiz_Session__c session = new Quiz_Session__c();
        insert session;
        sessionId = session.Id;
        
        Quiz_Question__c question = new Quiz_Question__c(
            Answer_A__c = 'A',
            Answer_B__c = 'B',
            Answer_C__c = 'C',
            Answer_D__c = 'D',
            Correct_Answer__c = 'A'
        );
        insert question;
        questionId = question.Id;

        session.Current_Question__c = questionId;
        update session;

        Quiz_Player__c player = new Quiz_Player__c(Name = 'Player' + DateTime.now().getTime());
        insert player;
        playerId = player.Id;

        Quiz_Answer__c answerA = new Quiz_Answer__c(Player__c = playerId, Question__c = questionId, Answer__c = 'A');
        Quiz_Answer__c answerB = new Quiz_Answer__c(Player__c = playerId, Question__c = questionId, Answer__c = 'B');
        insert new List<Quiz_Answer__c>{answerA, answerB};
    }

    @isTest
    static void testGetAnswerStats_HappyPath() {
        System.runAs(new User(Id = UserInfo.getUserId())) {
            QuizAnswerService service = new QuizAnswerService();
            Map<String, Integer> result = service.getAnswerStats();

            System.assertEquals(1, result.get('A'), 'Incorrect count for Answer A');
            System.assertEquals(1, result.get('B'), 'Incorrect count for Answer B');
        }
    }

    @isTest
    static void testGetAnswerStats_SadPath() {
        System.runAs(new User(Id = UserInfo.getUserId())) {
            delete [SELECT Id FROM Quiz_Answer__c WHERE Player__c = :playerId];

            QuizAnswerService service = new QuizAnswerService();
            Map<String, Integer> result = service.getAnswerStats();

            System.assertEquals(0, result.get('A'), 'Incorrect count for Answer A');
            System.assertEquals(0, result.get('B'), 'Incorrect count for Answer B');
        }
    }

    @isTest
    static void testGetAnswerStats_NoActiveSession() {
        System.runAs(new User(Id = UserInfo.getUserId())) {
            delete [SELECT Id FROM Quiz_Session__c WHERE Id = :sessionId];

            QuizAnswerService service = new QuizAnswerService();
            Map<String, Integer> result;
            try {
                result = service.getAnswerStats();
                System.assert(false, 'Exception should have been thrown');
            } catch(Exception e) {
                System.assert(true, 'Exception thrown as expected');
            }
            System.assertEquals(null, result, 'Result should be null as no active session');
        }
    }
}
