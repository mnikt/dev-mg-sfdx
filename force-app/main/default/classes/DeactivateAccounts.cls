/**
 * Created by mgieron on 05.07.2022.
 */

public with sharing class DeactivateAccounts {
    public static void deactivate(List<Account> accounts) {
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Account account : accounts) {
            if (account.Active__c == 'No') {
                for (Contact contact : account.Contacts) {
                    contact.isActive__c = false;
                    contact.Title = account.Description;
                    contactsToUpdate.add(contact);
                }
            }
        }
        update contactsToUpdate;
    }
}