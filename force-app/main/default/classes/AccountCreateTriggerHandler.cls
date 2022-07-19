/**
 * Created by mgieron on 15.07.2022.
 */

public with sharing class AccountCreateTriggerHandler {
    public static void handleCreate(Set<Id> accountsIds){
        generateRandomContactsForAccounts(accountsIds);
    }

    @Future(Callout=true)
    private static void generateRandomContactsForAccounts(Set<Id> accountIds){
        Integer numberOfAccounts = accountIds.size();

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://randomuser.me/api/?nat=gb&results=' + numberOfAccounts);
        req.setMethod('GET');

        HttpResponse response = new Http().send(req);
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
        if(response.getStatusCode() == 200) {
            List<RandomUser> randomUsers = ((RandomUserResult)JSON.deserialize(response.getBody(), RandomUserResult.class)).results;

            List<Contact> contacts = new List<Contact>();
            for (Integer i=0; i<numberOfAccounts; i++) {
                contacts.add(new Contact(FirstName=randomUsers[i].name.first,
                        LastName=randomUsers[i].name.last));
           //             AccountId=accountIds[i]));
            }
            insert contacts;
        }
    }

    public class RandomUserResult {
        public List<RandomUser> results;
    }
}