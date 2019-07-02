@isTest
private class Exam2PagesTest {

    @TestSetup
    private static void createData() {
        Product_Table__c product = new Product_Table__c(

                Name = 'Apple iPhone 5',
                Unit_Available__c = 10,
                Unit_Price__c = 2500
        );
        insert product;

        Contact contact = new Contact(
                FirstName = 'Steve',
                LastName = 'Jobs',
                Email = 'example123@gmail.com'
        );
        insert contact;
    }

    @isTest
    static void mainLogic() {

        Product_Table__c productFromBase = [
                SELECT Name, Unit_Available__c, Unit_Price__c
                FROM Product_Table__c
        ];

        Contact contactsFromBase = [
                SELECT FirstName,LastName,Email
                FROM Contact
        ];

        test.startTest();
        Exam3OrderRegistrationController controller = new Exam3OrderRegistrationController();
        controller.paramId = productFromBase.Id;
        controller.unitCount = 2;
        controller.contact.LastName = contactsFromBase.LastName;
        controller.contact.Email = contactsFromBase.Email;
        controller.orderBuy();
        test.stopTest();

        List<Order_Table__c> result = [
                SELECT Name, Product__c, Units__c, Contact__c, Order_Amount__c
                FROM Order_Table__c
        ];

        Product_Table__c resultProduct = [SELECT Id FROM Product_Table__c];
        Contact resultContact = [SELECT Email FROM Contact];

        System.AssertEquals(1, result.size());
        System.AssertEquals(resultProduct.Id, result[0].Product__c);
        System.AssertEquals(5000, result[0].Order_Amount__c);
        System.AssertEquals(resultContact.Id, result[0].Contact__c);
        System.AssertEquals(2, result[0].Units__c);

    }

    @isTest
    static void purchaseLimitExceeded() {

        Product_Table__c productFromBase = [
                SELECT Name, Unit_Available__c, Unit_Price__c
                FROM Product_Table__c
        ];

        Contact contactsFromBase = [
                SELECT FirstName,LastName,Email
                FROM Contact
        ];

        test.startTest();
        Exam3OrderRegistrationController controller = new Exam3OrderRegistrationController();
        controller.paramId = productFromBase.Id;
        controller.unitCount = 0;
        controller.getTotalAmount();
        controller.contact.LastName = contactsFromBase.LastName;
        controller.contact.Email = contactsFromBase.Email;
        controller.orderBuy();
        controller.unitCount = 11;
        controller.orderBuy();
        test.stopTest();

        List <Order_Table__c> result = [
                SELECT Id
                FROM Order_Table__c
        ];

        System.assertEquals(0, result.size());
    }

    @isTest
    static void existenceData() {
        test.startTest();
        Exam3Controller controller = new Exam3Controller();
        controller.productsFromBase();
        test.stopTest();

        System.assertEquals(1, controller.productsFromBase().size());
    }

    @isTest
    static void DescriptionControllerTest() {


        Product_Table__c productFromBase = [
                SELECT Name, Unit_Price__c
                FROM Product_Table__c
        ];


        test.startTest();
        PageReference pageRef = Page.Exam3Page;
        pageRef.getParameters().put('id', String.valueOf(productFromBase.Id));
        test.setCurrentPage(pageRef);
        Exam3DetailDescriptionController controller = new Exam3DetailDescriptionController();
        test.stopTest();

        List<Product_Table__c> result = [
                SELECT Name, Unit_Price__c
                FROM Product_Table__c
                WHERE Id = :productFromBase.Id
        ];
        system.assertEquals(1, result.size());
    }
}