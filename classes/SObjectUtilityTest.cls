@isTest
public class SObjectUtilityTest {
    static final Integer BULK_SIZE = 10;
    static testMethod void testGetIdsSet(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestRunningUser){ 
            List<Account> accounts = setup_data.createAccounts(BULK_SIZE);
            Test.startTest();
                Set<Id> ids = SObjectUtility.getIdsSet(accounts, 'Id');
            Test.stopTest();
            for(Account acc : accounts){
                System.assert(ids.contains(acc.Id), 'All ids should be in Set');

            }
        }
    }

    static testMethod void testIsFieldChanged_Negative(){
        Account test_old_record = AccountBuilder.getBuilder('Test ')
                        .setRecordTypeId(RecordTypeUtility.getIdByName(RecordTypeUtility.ACCOUNT_OFDE))
                        .setPostalCode('some')
                        .getRecord();
        Account test_new_record = test_old_record.clone(true, false);
        Map<Id, String> values_map = new Map<Id, String>();
        Test.startTest();
            Boolean is_changed = SObjectUtility.isFieldUpdated(test_old_record, test_new_record, 'BillingPostalCode', values_map);
        Test.stopTest();
        System.assert(!is_changed, 'Result Should be false as value not updated');
    }

    static testMethod void testIsFieldChanged_Positive(){
        Account test_old_record = AccountBuilder.getBuilder('Test ')
                        .setRecordTypeId(RecordTypeUtility.getIdByName(RecordTypeUtility.ACCOUNT_OFDE))
                        .setPostalCode('some')
                        .save()
                        .getRecord();
        Account test_new_record = test_old_record.clone(true, false);
        test_new_record.BillingPostalCode = 'new';
        Map<Id, String> values_map = new Map<Id, String>();
        Test.startTest();
            Boolean is_changed = SObjectUtility.isFieldUpdated(test_old_record, test_new_record, 'BillingPostalCode', values_map);
        Test.stopTest();
        System.assert(is_changed, 'Result Should be true as value updated');
        System.assertEquals(test_new_record.BillingPostalCode, values_map.get(test_new_record.Id), 'Last Value should be added to map');
    }

    class SetupDataClass{
        public User TestRunningUser;

        public SetupDataClass(){
            TestRunningUser = [SELECT Id, LastName FROM User WHERE FirstName='SYSADMIN' LIMIT 1];
        }

        public List<Account> createAccounts(Integer num_of_records){
            List<Account> accounts = new List<Account>();
            for(Integer i = 0; i < num_of_records; ++i){
                accounts.add(AccountBuilder.getBuilder()
                                        .setName('name' + i)
                                        .getRecord());
            }
            return accounts;
        }
    }

    @testSetup
    static void setupData(){
        UserTestData.getUserForTest().setProfile(ProfileUtilities.ProfileType.SYSADMIN)
                                     .setFirstName('SYSADMIN')
                                     .setLastName('asdasd')
                                     .save()
                                     .getRecord();
    }
}