@isTest
private class ProfileUtilitiesTest {
    static testMethod void testGetProfileIdReturnsValidProfileId() {
        Profile test_profile = [SELECT Id, Name FROM Profile LIMIT 1];
        SetupDataClass setup = new SetupDataClass();
        Test.startTest();
            setup.setProfileId(test_profile.Name);
        Test.stopTest();
        System.assertEquals(test_profile.Id, setup.ProfileId);
    }

    static testMethod void testGetNonExistingProfileNameReturnsNull() {
        SetupDataClass setup = new SetupDataClass();
        Test.startTest();
            setup.setProfileId('Some Fake Profile ');
        Test.stopTest();
        System.assertEquals(null, setup.ProfileId);
    }

    static testMethod void testGetProfileNameSystemAdministratorReturnsCorrectsValue() {
        SetupDataClass setup = new SetupDataClass();
        String expected_profile_name = ProfileUtilities.getInstance().getProfileName(ProfileUtilities.ProfileType.SYSADMIN);
        Test.startTest();
            String actual_profile_name = setup.ClassUnderTest.getProfileName(ProfileUtilities.ProfileType.SYSADMIN);
        Test.stopTest();
        System.assertEquals(expected_profile_name, actual_profile_name, 'The profile names don\'t match');
    }

    static testMethod void testGetProfileNameStandardUserReturnsCorrectsValue() {
        SetupDataClass setup = new SetupDataClass();
        String expected_profile_name = 'Standard User';
        Test.startTest();
            String actual_profile_name = setup.ClassUnderTest.getProfileName(ProfileUtilities.ProfileType.STANDARD_USER);
        Test.stopTest();
        System.assertEquals(expected_profile_name, actual_profile_name, 'The profile names don\'t match');
    }

    public class SetupDataClass{
        public Id ProfileId {get; private set;}
        public ProfileUtilities ClassUnderTest {get; private set;}

        public SetupDataClass() {
            ClassUnderTest = ProfileUtilities.getInstance();
        }

        public void setProfileId(String profile_name){
            profileId = ProfileUtilities.getProfileId(profile_name);
        }
    }
}