Package link: https://login.salesforce.com/packaging/installPackage.apexp?p0=04tWU000000AsGrYAK

Package password: password123



Run script in Dev Console to add some test records:

Object_A__c objectA = new Object_A__c(Name = 'Object A');
INSERT objectA;

List<Object_B__c> lstB = new List<Object_B__c>();
for (Integer i = 1; i <= 5; i++) {
    Object_B__c objectB = new Object_B__c(Name = 'Object B' + i, Object_A__c = objectA.Id);
    lstB.add(objectB);
}
INSERT lstB;

List<Object_C__c> lstC = new List<Object_C__c>();
for (Integer i = 1; i <= 25; i++) {
    Object_C__c objectC = new Object_C__c(Name = 'Object C' + i, Object_B__c = lstB[Integer.valueof((Math.random() * 4))].Id);
	lstC.add(objectC);
}
INSERT lstC;
