public class TriggerHandler {
    public static void onBeforeInsert (List<Account> acc1)
    {
        for (Account acc  : acc1) {
            system.debug('acc' +acc);
        if (acc.Type == null || acc.Type.trim() == '') {
            system.debug('acc' +acc.Type);
            acc.Type = 'Prospect';
        }
        }
    }
    public static void onBeforeInsert1 (List<Account> acc2)
    {
         for (Account acc : acc2) {
        // Check if the shipping address fields are not null or empty
        if ((acc.ShippingStreet != null && acc.ShippingStreet.trim() != '') ||
            (acc.ShippingCity != null && acc.ShippingCity.trim() != '') ||
            (acc.ShippingState != null && acc.ShippingState.trim() != '') ||
            (acc.ShippingPostalCode != null && acc.ShippingPostalCode.trim() != '') ||
            (acc.ShippingCountry != null && acc.ShippingCountry.trim() != '')) {

            // Copy shipping address to billing address
            acc.BillingStreet = acc.ShippingStreet;
            acc.BillingCity = acc.ShippingCity;
            acc.BillingState = acc.ShippingState;
            acc.BillingPostalCode = acc.ShippingPostalCode;
            acc.BillingCountry = acc.ShippingCountry;
        }
    }

    }
    public static void onBeforeInsert2 (List<Account> acc3){
        for(Account acc:acc3){
        if(acc.Phone!= null && acc.Website!=null && acc.Fax!=null){
            acc.Rating='Hot';
        }
    }
        
    
}
    public static void onAfterInsert(List<Account> acc4){
         List<Contact> con = new List<Contact>();
        for (Account acc : acc4) {
        // Create a new Contact with default values
        Contact defaultContact = new Contact(
            LastName = 'DefaultContact',
            Email = 'default@email.com',
            AccountId = acc.Id
        );

        // Add the new Contact to the list
        con.add(defaultContact);
    }

    // Insert all contacts at once
    if (!con.isEmpty()) {
        insert con;
    }
    }
    public static void onAfterUpdate (List<Opportunity> opp1)
    {
        for (Opportunity opp : opp1) {
        // Check if the Amount is less than or equal to 5000
        if (opp.Amount <= 5000) {
            // Add an error to the Amount field
            opp.addError('Opportunity amount must be greater than 5000');
        }
    }
    }
        public static void onBeforeUpdate (List<Opportunity> opp2){
            Set<Id> accountIds=new Set<Id>();
            for(Opportunity opp:opp2){
                if(opp.AccountId!=null){
                    accountIds.add(opp.AccountId);
                }
            }
            
        
        Map<Id,Contact>mapContact=new Map<Id,Contact>();
        if(!accountIds.isEmpty()){
            for(Contact contact:[SELECT Id,AccountId,Title FROM Contact WHERE AccountId IN:accountIds AND Title ='CEO']){
                mapContact.put(contact.AccountId,contact);
            }
        }

        for(Opportunity oppUpdt:opp2){
            if(mapContact.containsKey(oppUpdt.AccountId)){
                Contact ceoContact=mapContact.get(oppUpdt.AccountId);
                oppUpdt.Primary_Contact__c=ceoContact.Id;
            }
        }
    }
         public static void onBeforeDelete (List<Opportunity> opp3){
             Set<Id> accountIds1=new Set<Id>();
             
    
    // Iterate through each Opportunity to gather Account IDs
    for (Opportunity opp : opp3) {
        accountIds1.add(opp.AccountId);
    }
    
    // Query accounts to get the industries for the relevant Account IDs
    Map<Id, Account> accounts = new Map<Id, Account>([
        SELECT Id, Industry 
        FROM Account 
        WHERE Id IN :accountIds1
    ]);
             for(Opportunity opp:opp3){
                 // Check if the Opportunity is "Closed Won" and the associated Account is in the "Banking" industry
        if (opp.StageName == 'Closed Won' && accounts.containsKey(opp.AccountId) && accounts.get(opp.AccountId).Industry == 'Banking') {
            // Add an error to prevent deletion
            opp.addError('Cannot delete closed opportunity for a banking account that is won');
        }
    }
    
         }
}