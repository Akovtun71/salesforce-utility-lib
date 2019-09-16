@isTest
public class PickListUtilsTest {

    @isTest
    static void testGetDependentOptions(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                Map<String,List<String>> test_dependent_options_map = PickListUtils.getDependentOptions('Deal_Source__c','Sector__c','Sub_Sector__c');
            Test.stopTest();
            System.assertEquals(3, test_dependent_options_map.get('Business Services').size(), 'Wrong dependent picklist');
            List<String> test_picklist_values = setup_data.getDependentPicklistValues();
            for(Integer i = 0; i < test_picklist_values.size(); i++){
                System.assertEquals(test_picklist_values.get(i), test_dependent_options_map.get('Business Services').get(i), 'Wrong dependent picklist value');
            }
        }
    }

    @isTest
    static void testGetPicklistValuesNullNotRequired(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                List<String> options_list = PickListUtils.getPicklistValues('User_Time_Entry__c', 'Number_of_Days_worked__c', false);
            Test.stopTest();
            System.assertEquals(10, options_list.size(), 'Should be returned 10 picklist values');
            System.assertNotEquals('---None---', options_list[0], 'First value should not be filled with none value');
        }
    }

    @isTest
    static void testGetPicklistValuesNullRequired(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                List<String> options_list = PickListUtils.getPicklistValues('User_Time_Entry__c', 'Number_of_Days_worked__c', true);
            Test.stopTest();
            System.assertEquals(11, options_list.size(), 'Should be returned 10 picklist values and none value');
            System.assertEquals('---None---', options_list[0], 'First value should be filled with none value');
        }
    }

    private class SetupDataClass {
        public User TestUser;

        public SetupDataClass(){
            TestUser = [SELECT Id FROM User WHERE LastName = 'StageBarTest' LIMIT 1];
        }

        public List<String> getDependentPicklistValues(){
            return new List<String>{'Testing, Inspection & Compliance', 'Travel, Leisure & Gaming', 'Professional Services & BPO'};
        }
    }

    @testSetup static void createAndInsertTestData() {
        UserTestData.getUserForTest().setProfile(ProfileUtilities.ProfileType.SYSADMIN)
                .setFirstName('StageBarTest')
                .setLastName('StageBarTest')
                .save();
    }
}