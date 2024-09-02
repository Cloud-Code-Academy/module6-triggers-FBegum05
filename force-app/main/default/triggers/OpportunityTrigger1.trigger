trigger OpportunityTrigger1 on Opportunity (before insert, after update, before update, before delete) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        TriggerHandler.onAfterUpdate(Trigger.new);
    } else if (Trigger.isBefore && Trigger.isUpdate) {
        TriggerHandler.onBeforeUpdate(Trigger.new);
    } else if (Trigger.isBefore && Trigger.isDelete) {
        TriggerHandler.onBeforeDelete(Trigger.old);
    }
}


    

