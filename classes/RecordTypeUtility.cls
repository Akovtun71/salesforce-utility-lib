global without sharing class RecordTypeUtility {
    public static final String ACCOUNT_OFDE = 'Account.OFDE_Account';
    public static final String ACCOUNT_OFDE_ORGANIZATION = 'Account.OFDE_Organization';
    
    private static Map<String,String> MapRecordTypes;
    private static Map<String,String> MapRecordTypesReverse;
    static {
        String Key;
        Id RecTypeId;
        if (MapRecordTypes==null){
            List<RecordType> rt_list=[SELECT Id,Name,DeveloperName,SObjectType FROM RecordType];
            MapRecordTypes = new Map<String,String>();
            MapRecordTypesReverse = new Map<String,String>();
            for (RecordType rt : rt_list){ 
                Key = rt.SObjectType + '.' + rt.DeveloperName;
                RecTypeId = rt.Id;
                MapRecordTypes.put(Key ,RecTypeId);
                MapRecordTypesReverse.put(RecTypeId, Key);
            }
        }
    }

    public static String getKeyById(Id RecordTypeId){
        if (MapRecordTypesReverse.get(RecordTypeId) != null)
           return MapRecordTypesReverse.get(RecordTypeId);
        return null;
    }

    public static String getIdByName(String RecordTypeName){
        if (MapRecordTypes.containsKey(RecordTypeName)) return MapRecordTypes.get(RecordTypeName);
        return null;
    }

    public static String getNameById(Id RecordTypeId){
        RecordType  rt = [SELECT Id,Name FROM RecordType WHERE Id=:RecordTypeId];
        if (rt!=null) return rt.Name;
        return null;
    }

    public static RecordType getRecordTypeById(Id record_type_id){
        RecordType record_type = [SELECT Id, DeveloperName, Name FROM RecordType WHERE Id=:record_type_id];
        if (record_type != null) return record_type;
        return null;
    }
}
