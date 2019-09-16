public class SObjectUtility {
    public static Set<Id> getIdsSet(List<SObject> sobjects, String field_name){
        Set<Id> ids = new Set<Id>();
        for(Sobject sobj : sobjects){
            ids.add((Id)sobj.get(field_name));
        }
        return ids;
    }

    public static List<Id> getIdslist(List<SObject> sobjects, String field_name){
        List<Id> ids = new List<Id>();
        for(Sobject sobj : sobjects){
            ids.add((Id)sobj.get(field_name));
        }
        return ids;
    }

    public static Set<Object> getSetOfFieldValues(List<SObject> sobjects, String field_name, Set<Object> field_set){
        for(SObject sobj : sobjects){
            field_set.add(sobj.get(field_name));
        }
        return field_set;
    }

    public static List<Object> getListOfFieldValues(List<SObject> sobjects, String field_name, List<Object> field_values){
        for(SObject sobj : sobjects){
            field_values.add(sobj.get(field_name));
        }
        return field_values;
    }

    public static Map<Object, SObject> getFieldToRecordMap(List<SObject> sobjects, String field_name, Map<Object, SObject> values){
        for(SObject sobj : sobjects){
            values.put(sobj.get(field_name), sobj);
        }
        return values;
    }

    public static Map<Id, SObject> getIdToRecordMap(List<SObject> sobjects, String field_name, Map<Id, SObject> values){
        for(SObject sobj : sobjects){
            values.put((Id)sobj.get(field_name), sobj);
        }
        return values;
    }

    public static List<String> getFieldNamesOfObject(String object_name){
        Schema.DescribeSObjectResult sobject_describe = Schema.getGlobalDescribe().get(object_name).getDescribe();
        Map<String, Schema.SObjectField> fields = sobject_describe.fields.getMap();
        List<String> field_names = new List<String>();
        for(Schema.SObjectField field : fields.values()){
            field_names.add(field.getDescribe().getName());
        }
        return field_names;
    }

    public static List<String> getIdsStringList(List<Id> ids){
        List<String> ids_string_list = new List<String>();
        for(Id record_id : ids){
            ids_string_list.add(String.valueOf(record_id));
        }
        return ids_string_list;
    }

    public static Boolean isFieldUpdated(SObject old_object, SObject new_object, String field_name, Map<Id, Object> old_values){
        Object old_value = old_values.get(old_object.Id);
        if(old_value == null){
            old_value = old_object.get(field_name);
        }
        if(old_value != new_object.get(field_name)){
            old_values.put(new_object.Id, new_object.get(field_name));
            return true;
        }
        return false;
    }
}