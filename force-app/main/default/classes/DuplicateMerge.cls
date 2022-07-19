/**
 * Created by mgieron on 05.07.2022.
 */
public with sharing class DuplicateMerge {
    public static SObject mergeDuplicates(SObject master, SObject other){
        SObject mergedObject = master.clone();
        Map<String, Object> otherFieldsMap = other.getPopulatedFieldsAsMap();
        for (String key : otherFieldsMap.keySet()) {
            if(mergedObject.get(key) == null){
                try {
                    mergedObject.put(key, otherFieldsMap.get(key));
                } catch(Exception e) {
                    System.debug('Info: Could not merge field ' + key);
                }
            }
        }
        return mergedObject;
    }
}