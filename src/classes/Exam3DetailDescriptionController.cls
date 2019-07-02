public with sharing class Exam3DetailDescriptionController {

    public Product_Table__c product {
        get;
        set;
    }
    public Exam3DetailDescriptionController() {
        Id productId = Apexpages.currentPage().getParameters().get('Id');
        product = [
                SELECT Id, Name, Image_Url__c, Product__c, Unit_Available__c
                FROM Product_Table__c
                WHERE Id = :productId
        ];
    }
}