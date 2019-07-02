public with sharing class Exam3OrderRegistrationController {

    public Contact contact { get; set; }
    public Integer unitCount { get; set; }
    public Id paramId { get; set; }
    public Decimal totalAmount {get;set;}
    public Product_Table__c getProductDetail {
        get {
            if (ApexPages.currentPage().getParameters().containsKey('id') &&
                    ApexPages.currentPage().getParameters().get('id') != null) {
                paramId = ApexPages.currentPage().getParameters().get('id');
            }
            return [
                    SELECT Name, Image_Url__c, Product__c, Unit_Price__c, Unit_Available__c
                    FROM Product_Table__c
                    WHERE Id = :paramId
            ];
        }
        set;
    }

    public void getTotalAmount(){
    totalAmount = unitCount * getProductDetail.Unit_Price__c;

    }


    public Exam3OrderRegistrationController() {

        contact = new Contact();
    }

    public void orderBuy() {

        upsert contact Email;
        Boolean errorLogicSwitcher = false;

        if (unitCount == 0) {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Invalid value for field'));
        } else {

            if (errorLogicSwitcher == false) {

                if (getProductDetail.Unit_Available__c < unitCount) {

                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                            'Maximum amount you can buy:'
                                    + ' ' + getProductDetail.Unit_Available__c));
                } else {

                    Integer balance = Integer.valueOf(getProductDetail.Unit_Available__c) - Integer.valueOf(unitCount);
                    Order_Table__c newOrderTable = new Order_Table__c(

                            Product__c = getProductDetail.Id,
                            Units__c = unitCount,
                            Contact__c = contact.Id,
                            Order_Amount__c = unitCount * getProductDetail.Unit_Price__c
                    );
                    insert newOrderTable;

                    Product_Table__c prodTableEdit = [
                            SELECT Name, Unit_Available__c
                            FROM Product_Table__c
                            WHERE Id = :getProductDetail.Id
                    ];

                    prodTableEdit.Unit_Available__c -= unitCount;
                    update prodTableEdit;

                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,
                            'The_purchase_was_successful'));
                    contact.clear();
                    unitCount = 1;

                }
            }
        }
    }
}