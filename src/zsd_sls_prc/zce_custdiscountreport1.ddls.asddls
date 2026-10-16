@EndUserText.label: 'Customer Discount Report Custom Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CUST_DISCOUNT_API_REPORT1'
@Search.searchable: true

define custom entity ZCE_CUSTDISCOUNTREPORT1
{
      @UI.lineItem          : [{ position: 10, label: 'Sales Order No' }]
      @UI.selectionField    : [{ position: 10 }]
      @Search.defaultSearchElement: true
  key salesdocument         : abap.char(10);

      @UI.lineItem          : [{ position: 20, label: 'PO Line No' }]
  key salesdocumentitem     : abap.numc(6);

      @UI.lineItem          : [{ position: 30, label: 'Sales Order Date' }]
      salesdocumentdate     : abap.dats;

      @UI.lineItem          : [{ position: 40, label: 'Customer PO No' }]
      purchaseorderbycust   : abap.char(35);

      @UI.lineItem          : [{ position: 50, label: 'Customer PO Date' }]
      customerpodate        : abap.dats;

      @UI.lineItem          : [{ position: 60, label: 'Cust Reqd Dt-Header (CRD)' }]
      @UI.selectionField    : [{ position: 30 }]
      requesteddeliverydate : abap.dats;

      @UI.lineItem          : [{ position: 65, label: 'Customer' }]
      @UI.selectionField    : [{ position: 20 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Customer', element: 'Customer' } }]
      soldtoparty           : abap.char(10);

      @UI.lineItem          : [{ position: 70, label: 'Material Code' }]
      material              : abap.char(40);

      @UI.lineItem          : [{ position: 80, label: 'Material Description' }]
      salesdocumentitemtext : abap.char(40);

      // --- UNITS OF MEASURE & QUANTITIES ---

      @Semantics.unitOfMeasure: true
      orderquantityunit     : abap.unit(3);

      @UI.lineItem          : [{ position: 90, label: 'Order Quantity' }]
      @Semantics.quantity.unitOfMeasure: 'orderquantityunit'
      orderquantity         : abap.quan(13,3);

      @UI.lineItem          : [{ position: 100, label: 'STD Unit Wt (KG)' }]
      stdunitweight         : abap.dec(12,3);

      @UI.lineItem          : [{ position: 110, label: 'Total Weight (KG)' }]
      @Semantics.quantity.unitOfMeasure: 'orderquantityunit'
      totalweightkg         : abap.quan(13,3);

      // --- CURRENCY KEY & AMOUNTS ---

      @Semantics.currencyCode:true
      transactioncurrency   : abap.cuky;

      @UI.lineItem          : [{ position: 120, label: 'Unit Price (ZPR0)' }]
      @Semantics.amount.currencyCode: 'transactioncurrency'
      unitprice             : abap.curr(15,2);

      @UI.lineItem          : [{ position: 130, label: 'Total Price' }]
      @Semantics.amount.currencyCode: 'transactioncurrency'
      totalprice            : abap.curr(15,2);

      @UI.lineItem          : [{ position: 140, label: 'Total Wt (MT)' }]
      totalweightmt         : abap.dec(12,3);

      @UI.lineItem          : [{ position: 150, label: 'Value / MT' }]
      @Semantics.amount.currencyCode: 'transactioncurrency'
      valuepermt            : abap.curr(15,2);

      @UI.lineItem          : [{ position: 160, label: 'Discount %' }]
      discountpct           : abap.dec(5,2);

      @UI.lineItem          : [{ position: 170, label: 'Discount Value' }]
      @Semantics.amount.currencyCode: 'transactioncurrency'
      discountval           : abap.curr(15,2);
}
