public with sharing class ProfileUtilities {
    public enum ProfileType {
        STANDARD_USER,
        SYSADMIN
    }

    private final Map<ProfileType, String> ProfileNameMap = new Map<ProfileType, String>{
            ProfileType.STANDARD_USER => 'Standard User',
            ProfileType.SYSADMIN => 'System Administrator'

    };

    private Map<String,Id> MapProfileIds;
    private Map<Id,String> MapUserTypes;

    private static ProfileUtilities InstanceOfProfileUtilities = null;
    private static Map<String,String> MapProfileIds;

    static {
        if(MapProfileIds == null){
            MapProfileIds = new Map<String,String>();
            for (Profile user_profile : [SELECT id, Name, UserType FROM Profile]){
                MapProfileIds.put(user_profile.Name, user_profile.Id);
            }
        }
    }

    private ProfileUtilities() {
        this.MapProfileIds = new Map<String,Id>();
        this.MapUserTypes = new Map<Id,String>();
        for (Profile user_profile : [SELECT Id, Name, UserType FROM Profile]){
            this.MapProfileIds.put(user_profile.Name, user_profile.Id);
            this.MapUserTypes.put(user_profile.Id, user_profile.UserType);
        }
    }

    public static ProfileUtilities getInstance() {
        if(InstanceOfProfileUtilities == null) InstanceOfProfileUtilities = new ProfileUtilities();
        return InstanceOfProfileUtilities;
    }

    public String getProfileName(ProfileType profile_type) {
        return ProfileNameMap.get(profile_type);
    }

    public static String getProfileId(String profile_name){
        if(MapProfileIds.containsKey(profile_name))
            return MapProfileIds.get(profile_name);
        return null;
    }
}