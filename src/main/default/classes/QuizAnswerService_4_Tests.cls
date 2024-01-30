
@isTest
public class QuizAnswerService_4_Tests {

    @testSetup
    static void setup() {
        // Create some test data
        List<Player__c> players = new List<Player__c>();
        for(Integer i=0; i<5; i++) {
            Player__c player = new Player__c(PlayerName__c='testPlayer'+i); // replace 'Name' with the correct field from Player__c
            players.add(player);
        }
        insert players;

        List<Quiz_Answer__c> answers = new List<Quiz_Answer__c>();
        for(Player__c player : players) {
            Quiz_Answer__c answer = new Quiz_Answer__c(Player__c= player.Id, Answer__c = 'A');
            answers.add(answer);
        }
        insert answers;
    }

    @isTest
    static void testGetUniquePlayerIds_MultiplePlayers() {
        // Arrange
        List<Quiz_Answer__c> answers = [SELECT Player__c, Answer__c FROM Quiz_Answer__c];
        QuizAnswerService service = new QuizAnswerService();

        // Act
        Set<Id> uniquePlayerIds = service.getUniquePlayerIds(answers);

        // Assert
        System.assertEquals(5, uniquePlayerIds.size());
    }

    @isTest
    static void testGetUniquePlayerIds_SinglePlayer() {
        // Arrange
        Player__c testPlayer = [SELECT Id FROM Player__c WHERE PlayerName__c = 'testPlayer1']; // replace 'Name' with the correct field from Player__c
        List<Quiz_Answer__c> answers = new List<Quiz_Answer__c>();
        for(Integer i=0; i<5; i++) {
            Quiz_Answer__c answer = new Quiz_Answer__c(Player__c= testPlayer.Id, Answer__c = 'A');
            answers.add(answer);
        }
        insert answers;
        QuizAnswerService service = new QuizAnswerService();

        // Act
        Set<Id> uniquePlayerIds = service.getUniquePlayerIds(answers);

        // Assert
        System.assertEquals(1, uniquePlayerIds.size());
    }

    @isTest
    static void testGetUniquePlayerIds_EmptyList() {
        // Arrange
        List<Quiz_Answer__c> answers = new List<Quiz_Answer__c>();
        QuizAnswerService service = new QuizAnswerService();

        // Act
        Set<Id> uniquePlayerIds = service.getUniquePlayerIds(answers);

        // Assert
        System.assertEquals(0, uniquePlayerIds.size());
    }
}
