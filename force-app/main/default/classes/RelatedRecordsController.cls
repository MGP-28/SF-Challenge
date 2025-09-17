public with sharing class RelatedRecordsController {
    public RelatedRecordsController() {
        //
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getRelatedRecords(Id recordId, Integer pageNumber, Integer pageSize, Integer lastRecord1, Integer lastRecord2) {
        Integer lastTableRecord = pageNumber * pageSize;
        Integer newLastRecord1;
        Integer newLastRecord2;

        if (pageNumber == 1) {
            newLastRecord1 = pageSize;
            newLastRecord2 = 0;
        } 
        else if (lastRecord1 > lastTableRecord) {
            newLastRecord1 = lastTableRecord;
            newLastRecord2 = 0;
        } 
        else {
            newLastRecord1 = lastRecord1;
            newLastRecord2 = (lastTableRecord - lastRecord1);
        }

        List<SObject> recordList = new List<SObject>();
        if (newLastRecord2 == 0) {
            List<SObject> objectBRecs = [SELECT Id, Name FROM Object_B__c WHERE Object_A__c = :recordId LIMIT :pageSize OFFSET :(newLastRecord1 - pageSize)];
            recordList.addAll(objectBRecs);
            
            if (recordList.size() < pageSize) {
                newLastRecord2 = pageSize - recordList.size();
                newLastRecord1 -= pageSize - recordList.size();
            }
        }

        if (newLastRecord2 != 0) {
            List<SObject> objectCRecs = [SELECT Id, Name FROM Object_C__c WHERE Object_B__c IN (SELECT Id FROM Object_B__c WHERE Object_A__c = :recordId) LIMIT :(pageSize - recordList.size()) OFFSET :(newLastRecord2 - pageSize + recordList.size())];
            recordList.addAll(objectCRecs);
            if (recordList.size() < pageSize) {
                newLastRecord2 -= pageSize - recordList.size();
            }
        }

        Map<String, Object> result = new Map<String, Object>();
        result.put('records', recordList);
        result.put('totalRecords', recordList.size());
        result.put('lastRecord1', newLastRecord1);
        result.put('lastRecord2', newLastRecord2);

        return result;
    }
}