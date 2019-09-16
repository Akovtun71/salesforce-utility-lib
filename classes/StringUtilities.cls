public with sharing class StringUtilities {
    public static String format(String format, Object arg1) {
        return String.format(format.replaceAll('\'', '\'\''), new String[]{
                String.valueOf(arg1)
        });
    }

    public static Boolean checkIfStringListContainsStringIgnoreCase(List<String> listOfStrings, String stringToCheck) {
        if (listOfStrings != null && stringToCheck != null) {
            for (Integer i = 0; i < listOfStrings.size(); i++) {
                if (listOfStrings.get(i).toLowerCase() == stringToCheck.toLowerCase()) {
                    return true;
                }
            }
        }
        return false;
    }
}