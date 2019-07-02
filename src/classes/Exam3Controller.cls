public with sharing class Exam3Controller {
    public List<Product_Table__c> AllProducts { get; set; }
    public Exam3Controller() {
        productsFromBase();
    }
    public List <Product_Table__c> productsFromBase() {
        AllProducts = [
                SELECT Name, Unit_Price__c, Image_Url__c, Warehouse__c, Product__c
                FROM Product_Table__c
        ];
        return AllProducts;
    }
}

