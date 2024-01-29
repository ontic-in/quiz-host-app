
@isTest
private class QuizAnswerService_8_Tests {
    
    // This method will setup test data that can be used across all test methods
    @testSetup
    static void setup() {
        // In this case, we don't really need to set up any data since we're testing a constructor
    }

    // Test the happy path for PlayerStats constructor
    @isTest
    static void testPlayerStatsConstructorHappyPath() {
        // Arrange - Prepare the test data
        Integer wrongCount = 1;
        Integer correctCount = 4;
        Integer totalCount = 5;
        Decimal score = 85.0;
        Integer rank = 2;
        String name = 'Test Player';

        // Act - Create a new PlayerStats instance
        QuizAnswerService.PlayerStats playerStats = new QuizAnswerService.PlayerStats(
            wrongCount,
            correctCount,
            totalCount,
            score,
            rank,
            name
        );

        // Assert - Verify the properties are set correctly
        System.assertEquals(wrongCount, playerStats.wrongCount, 'The wrongCount should be set correctly');
        System.assertEquals(correctCount, playerStats.correctCount, 'The correctCount should be set correctly');
        // Assertions for score, rank, and name would follow the same pattern
    }
}
