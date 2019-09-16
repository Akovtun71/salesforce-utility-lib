@IsTest
private class StringUtilitiesTest {
    @IsTest
    private static void test_format_returnsSourceStringWithInsertedParam() {
        String sourceString = '1 - one, 2 - {0}, 3 - three';
        String stringToInsert = 'TWO';

        Test.startTest();
        String formattedString = StringUtilities.format(sourceString, stringToInsert);
        Test.stopTest();

        System.assertEquals('1 - one, 2 - TWO, 3 - three', formattedString, 'string to insert should be inserted to source string');
    }

    @IsTest
    private static void test_checkIfStringListContainsStringIgnoreCase_whenListContainsTheString() {
        List<String> testListOfStrings = new List<String>{'one', 'two', 'three', 'four', 'five'};

        Test.startTest();
        Boolean checkResult = StringUtilities.checkIfStringListContainsStringIgnoreCase(testListOfStrings, 'FoUr');
        Test.stopTest();

        System.assert(checkResult, 'Check should return true because the element exists in the list');
    }

    @IsTest
    private static void test_checkIfStringListContainsStringIgnoreCase_whenListDoesNotContainTheString() {
        List<String> testListOfStrings = new List<String>{'one', 'two', 'three', 'four', 'five'};

        Test.startTest();
        Boolean checkResult = StringUtilities.checkIfStringListContainsStringIgnoreCase(testListOfStrings, 'seven');
        Test.stopTest();

        System.assert(!checkResult, 'Check should return false because the element does not exist in the list');
    }
}