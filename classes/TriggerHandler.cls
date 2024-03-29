public abstract class TriggerHandler {
    public static Boolean IsTriggerActive = true;
    public enum TriggerOperation {IS_INSERT, IS_UPDATE, IS_DELETE}

    protected Map<Id, SObject> oldMap {get; set;}
    protected Map<Id, SObject> newMap {get; set;}
    protected List<SObject> oldList {get; set;}
    protected List<SObject> newList {get; set;}
    protected TriggerOperation operation {get; set;}

    public TriggerHandler(Map<Id, SObject> oldMap, Map<Id, SObject> newMap,
            List<SObject> oldList, List<SObject> newList) {
        this.oldMap = oldMap;
        this.newMap = newMap;
        this.oldList = oldList;
        this.newList = newList;

        if (oldList == null) {
            this.operation = TriggerOperation.IS_INSERT;
        } else if (newList == null) {
            this.operation = TriggerOperation.IS_DELETE;
        } else {
            this.operation = TriggerOperation.IS_UPDATE;
        }
    }

    public virtual void beforePostProcessing(){}

    public interface ITrigger {
        void bulkBefore();
        void bulkAfter();
        void beforeInsert(SObject so);
        void beforeUpdate(SObject oldSo, SObject so);
        void beforeDelete(SObject so);
        void afterInsert(SObject so);
        void afterUpdate(SObject oldSo, SObject so);
        void afterDelete(SObject so);
        void postProcessing();
        void beforePostProcessing();
    }
}
