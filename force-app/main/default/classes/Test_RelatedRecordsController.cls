@isTest
public with sharing class Test_RelatedRecordsController {
    public Test_RelatedRecordsController() {
        //
    }

    @TestSetup
    public static void makeData(){
        Object_A__c objectA = new Object_A__c(Name = 'Object A');
        insert objectA;

        Object_B__c objectB = new Object_B__c(Name = 'Object B', Object_A__c = objectA.Id);
        insert objectB;

        Object_C__c objectC = new Object_C__c(Name = 'Object C', Object_B__c = objectB.Id);
        insert objectC;
    }

    @isTest
    public static void testCase(){
        
        Test.startTest();
        
        Object_A__c objectA = [SELECT Id FROM Object_A__c LIMIT 1];
        Map<String,Object> results = RelatedRecordsController.getRelatedRecords(objectA.Id, 1, 10, 0, 0);

        Test.stopTest();

        System.assertEquals(2, results.get('totalRecords'), 'Should be 2');
        System.assertEquals(1, results.get('lastRecord1'), 'Should be 1');
        System.assertEquals(1, results.get('lastRecord2'), 'Should be 1');  
    }
}