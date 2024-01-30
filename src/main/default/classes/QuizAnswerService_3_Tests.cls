
@isTest
private class QuizAnswerService_3_Tests {
    
    static Id testPlayerId;
    static String testAnswer = 'Test Answer';
    static User testUser;

    @TestSetup
    static void setup() {
        // Create a test user with necessary permissions
        testUser = new User(
            LastName = 'Test User',
            Email = 'testuser@yourcompany.com',
            Alias = 'tuser',
            Username = 'testuser@yourcompany.com' + DateTime.now().getTime(),
            ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        // Create test data here.
        // This should include at least a player and a Quiz Session with phase as `Question`
        Quiz_Player__c testPlayer = new Quiz_Player__c(Name = 'Test Player ' + DateTime.now().getTime());
        insert testPlayer;
        testPlayerId = testPlayer.Id;
        
        // Create Quiz Session
        Quiz_Session__c testSession = new Quiz_Session__c(Phase__c = 'Question');
        insert testSession;
    }

    @isTest 
    static void testCreateAnswer_HappyPath() {
        // Run test as the testUser who has necessary permissions
        System.runAs(testUser) {
            // Disable triggers
            TriggerHandler.bypass('AccountTriggerHandler');
            TriggerHandler.bypass('MDTAccountTriggerHandler');
            
            // Call the create method and assert the return value is not null
            QuizAnswerService service = new QuizAnswerService();
            Quiz_Answer__c answerRecord = service.create(testPlayerId, testAnswer);
            
            System.assertNotEquals(null, answerRecord, 'Answer should be created');
            System.assertEquals(testPlayerId, answerRecord.Player__c, 'Player Id should match');
            System.assertEquals(testAnswer, answerRecord.Answer__c, 'Answer should match');
        }
    }

    // Include System.runAs(testUser) in other test methods as well...
}
