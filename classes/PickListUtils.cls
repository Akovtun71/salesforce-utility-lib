public with sharing class PickListUtils {

    public static List<String> getPicklistValues(String object_name, String field_api_name, Boolean null_required) {
        List<String> options_list = new List<String>();
        Map<String, Schema.SObjectField> fields_map = Schema.getGlobalDescribe().get(object_name.toLowerCase()).getDescribe().fields.getMap();
        List<Schema.PicklistEntry> picklist_values_list = fields_map.get(field_api_name).getDescribe().getPickListValues();

        if (null_required == true) {
            options_list.add('---None---');
        }

        for (Schema.PicklistEntry picklist_value : picklist_values_list) {
            options_list.add(picklist_value.getValue());
        }
        return options_list;
    }

    public class Bitset {
        public Map<Integer, Integer> Base64CharCodes = new Map<Integer,Integer>{65=>0,66=>1,67=>2,68=>3,69=>4,70=>5,71=>6,72=>7,
        73=>8,74=>9,75=>10,76=>11,77=>12,78=>13,79=>14,80=>15,81=>16,82=>17,83=>18,84=>19,85=>20,86=>21,87=>22,88=>23,89=>24,90=>25
        ,97=>26,98=>27,99=>28,100=>29,101=>30,102=>31,103=>32,104=>33,105=>34,106=>35,
        107=>36,108=>37,109=>38,110=>39,111=>40,112=>41,113=>42,114=>43,115=>44,116=>45,117=>46,118=>47,119=>48,120=>49,121=>50,122=>51
        ,48=>52,49=>53,50=>54,51=>55,52=>56,53=>57,54=>58,55=>59,56=>60,57=>61,43=>62,47=>63};


        public List<Integer> base64ToBytes(String base64) {
            List<Integer> bytes = new List<Integer>();
            if ( base64 == null || base64 == '' ) {
                return bytes;
            }

            base64 += '='.repeat( 4 - Math.mod( base64.length(), 4));

            for ( Integer j = 0; j < base64.length(); j += 4 ) {
                if ( Base64CharCodes.get(base64.charAt(j+1)) != null ) {
                    bytes.add( (Base64CharCodes.get(base64.charAt(j)) << 2) | (Base64CharCodes.get(base64.charAt(j+1)) >>> 4) );
                }
                if ( Base64CharCodes.get(base64.charAt(j+2)) != null ) {
                    bytes.add( ((Base64CharCodes.get(base64.charAt(j+1)) & 15) << 4) | (Base64CharCodes.get(base64.charAt(j + 2)) >>> 2) );
                }
                if ( Base64CharCodes.get(base64.charAt(j+3)) != null ) {
                    bytes.add( ((Base64CharCodes.get(base64.charAt(j+2)) & 3) << 6) | Base64CharCodes.get(base64.charAt(j + 3)) );
                }
            }
            return bytes;
        }

        public List<Integer> convertBits(String base64) {
            List<Integer> bytes = new List<Integer>();
            if ( base64 == null || base64 == '' ) {
                return bytes;
            }
            List<Integer> list_bytes = base64ToBytes(base64);
            Integer value;
            for (Integer i = 0; i < list_bytes.size(); i++ ) {
                value = list_bytes[i];
                for (Integer b = 1; b <= 8; b++ ) {
                    if ( ( value & 128 ) == 128 ) {
                        bytes.add( (i*8) + b );
                    }
                    value <<= 1;
                }
            }
            return bytes;
        }
    }

    public static Map<String,List<String>> getDependentOptions(String object_name, String controlling_field_name, String dependent_field_name) {
        Map<String,List<String>> object_results = new Map<String,List<String>>();
        Schema.SObjectType object_type = Schema.getGlobalDescribe().get(object_name);
        if ( object_type == null ) {
            return object_results;
        }
        Map<String, Schema.SObjectField> object_field_map = object_type.getDescribe().fields.getMap();
        if (!object_field_map.containsKey(controlling_field_name) || !object_field_map.containsKey(dependent_field_name)) {
            return object_results;
        }
        List<Schema.PicklistEntry> controlling_picklist = object_field_map.get(controlling_field_name).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> depending_picklist = object_field_map.get(dependent_field_name).getDescribe().getPicklistValues();
        object_field_map = null;
        for(Integer i = 0; i < controlling_picklist.size(); i++){
            Schema.PicklistEntry ctrl_entry = controlling_picklist[i];
            String controlling_label = ctrl_entry.getLabel();
            object_results.put(controlling_label, new List<String>());
        }
        List<PicklistDetails> picklist_details_list = new List<PicklistDetails>();
        picklist_details_list = (List<PicklistDetails>)JSON.deserialize(JSON.serialize(depending_picklist), List<PicklistDetails>.class);

        Map<PicklistDetails, Schema.PicklistEntry> picklist_details_to_entry = new Map<PicklistDetails, Schema.PicklistEntry>();

        List<Integer> valid_indexes;
        Bitset object_bitSet = new Bitset();
        for (PicklistDetails picklist_detail : picklist_details_list) {
            valid_indexes = object_bitSet.convertBits(picklist_detail.validFor);
            for (Integer valid_index : valid_indexes){
                String controlling_label = controlling_picklist[valid_index-1].getLabel();
                object_results.get(controlling_label).add(picklist_detail.label);
            }
        }
        picklist_details_list = null;
        return object_results;
    }

    public class PicklistDetails {
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public String label {get;set;}
    }
}