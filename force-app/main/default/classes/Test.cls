/**
 * Created by mgieron on 15.07.2022.
 */

@IsTest
public with sharing class Test {
    @IsTest
    static void testSomething(){
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='a1'));
        accounts.add(new Account(Name='a2'));
        accounts.add(new Account(Name='a3'));
        insert accounts;
    }
}