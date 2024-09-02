trigger AccountTrigger1 on Account (before insert,after insert,before update,after update) {
    if(Trigger.isBefore)
    {
        system.debug('isbefore' +Trigger.isBefore);
        if(Trigger.isInsert){
            system.debug('isInsert' +Trigger.isInsert);
            TriggerHandler.onBeforeInsert(Trigger.new);
            TriggerHandler.onBeforeInsert1(Trigger.new);
            TriggerHandler.onBeforeInsert2(Trigger.new);
            
        }
    }
    else if(Trigger.isAfter){
        if(Trigger.isInsert){
      TriggerHandler.onAfterInsert(Trigger.new);
    }
}
}