@ObjectModel.query.implementedBy: 'ABAP:ZCL_TAXINV_IMPL'
@EndUserText.label: 'Custom Entity for Tax Invoices'
define custom entity ZCUS_TAXINV
{
  key BillingDocument             : vbeln_vl;
      DocumentReferenceID         : abap.char(16);
      BillingDocumentDate         : fkdat;
      IN_EDocEInvcEWbillNmbr      : abap.numc(12);
      IN_ElectronicDocInvcRefNmbr : abap.char(64);
      IN_ElectronicDocQRCodeTxt   : abap.string(1000);
      caddress1                   : abap.char(100);
      caddress2                   : abap.char(100);
      caddress3                   : abap.char(100);
      name                        : abap.char(75);
      plantname                   : abap.char(100);
      plantaddr1                  : abap.char(100);
      plantaddr2                  : abap.char(100);
      plantaddr3                  : abap.char(100);
      gstin                       : abap.char(50);
      tin                         : abap.char(50);
      cinno                       : abap.char(50);
      panno                       : abap.char(10);
      Delmode                     : abap.char(20);
      Pod                         : abap.char(100);
      Carsealno                   : abap.char(40);
      Contno                      : abap.char(200);
      Vehno                       : abap.char(12);
      lrno                        : abap.char(10);
      ReferenceSDDocument         : abap.char(10);
      customername                : abap.char(100);
      address                     : abap.char(300);
      LUTNo                       : abap.char(50);
      LUTdt                       : abap.char(50);
      amtintext                   : abap.char(256);
      amtintextdom                : abap.char(256);
      textfield1                  : abap.char(50);
      textfield2                  : abap.char(50);
      textfield3                  : abap.char(50);
      textfield4                  : abap.char(50);
      customernamedeltax          : abap.char(100);
      addressdeltax               : abap.char(300);
      regioncodedeltax            : abap.char(4);
      regionnamedeltax            : abap.char(75);
      gstindeltax                 : abap.char(20);
      pannodeltax                 : abap.char(20);
      gstinship                   : abap.char(20);
      pannoship                   : abap.char(20);
      regioncodesh                : abap.char(4);
      regionnamesh                : abap.char(75);
      PurchaseOrderByCustomer     : abap.char(75);
      Lc_Appl                     : abap.char(40);
      ShippingBill                : abap.char(30);
      ShippingBillDate            : sydate;
      Lc_Open_Dt                  : sydate;
      Banka                       : abap.char(60);
      pkgsum                      : abap.numc( 5 );
      billingunit                 : meins;
      @Semantics.quantity.unitOfMeasure : 'BillingUnit'
      netwtsum                    : abap.quan(13,3);
      _item                       : association [1..*] to ZCDS_TAXINVITM on $projection.BillingDocument = _item.BillingDocument;
      _item1                      : association [1..*] to ZCDS_DOMESTIC_TAXITM on $projection.BillingDocument = _item1.BillingDocument;
}
