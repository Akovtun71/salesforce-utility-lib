@isTest
public class UserTestData {
    public static Builder getUserForTest(){
        return new Builder();
    }

    public class Builder{
        private User Record;

        private Builder(){
            Record = new User();
            Record.Username = 'testuser' + getRandomString(5) + '@test.test';
            Record.Email = Record.Username;
            Record.Alias = getRandomString(5);
            Record.LastName = 'TestMan';
            Record.IsActive = true;
            Record.EmailEncodingKey = 'UTF-8';
            Record.TimeZoneSidKey = 'Europe/London';
            Record.LanguageLocaleKey = 'en_US';
            Record.LocaleSidKey = 'en_IE_EURO';
        }

        public String getRandomString(Integer length) {
            String key = EncodingUtil.convertToHex(crypto.generateAesKey(128));
            return key.substring(0, length);
        }

        public Builder save(){
            insert Record;
            return this;
        }

        public Builder setFirstName(String first_name){
            Record.FirstName = first_name;
            return this;
        }

        public Builder setLastName(String last_name){
            Record.LastName = last_name;
            return this;
        }

        public Builder setUserRole(String user_role){
            Record.UserRoleId = [SELECT Id FROM UserRole WHERE Name = :user_role LIMIT 1].Id;
            return this;
        }

        public Builder setProfile(ProfileUtilities.ProfileType profile_type){
            String profile_name = ProfileUtilities.getInstance().getProfileName(profile_type);
            String profile_id = ProfileUtilities.getProfileId(profile_name);
            Record.ProfileId = profile_id;
            return this;
        }

        public User getRecord(){
            return Record;
        }
    }
}