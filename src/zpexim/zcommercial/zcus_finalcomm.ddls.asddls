@ObjectModel.query.implementedBy: 'ABAP:ZCL_FINALCOMM_IMPL'
@EndUserText.label: 'Draft Packing List'
define custom entity ZCUS_FINALCOMM

{
  key BillingDocument             : vbeln;
      pol                         : abap.char(100);
      pod                         : abap.char(100);
      coo                         : abap.char(100);
      cod                         : abap.char(100);
      cusmar                      : abap.char(100);
      descgoods                   : abap.char(100);
      precarby                    : abap.char(30);
      por                         : abap.char(60);
      placedel                    : abap.char(100);
      vesselno                    : abap.char(30);
      contno                      : abap.char(200);
      PurchaseOrderByCustomer     : bstkd;
      CreationDate                : erdat;
      caddress1                   : abap.char(100);
      caddress2                   : abap.char(100);
      name                        : abap.char(75);
      gstin                       : abap.char(50);
      cinno                       : abap.char(50);
      iec                         : abap.char(50);
      Findes                      : abap.char(75);
      Carsealno                   : abap.char(200);
      meins                       : meins;
      @Semantics.quantity.unitOfMeasure : 'meins'
      sumgrosswt                  : abap.quan(13,3);
      @Semantics.quantity.unitOfMeasure : 'meins'
      sumnetwt                    : abap.quan(13,3);
      ShippingBill                : abap.char(200);
      ShippingBillDate            : abap.dats;
      Descgoods1                  : abap.char(500);
      Descgoods2                  : abap.char(500);
      Remarks1                    : abap.char(500);
      Remarks2                    : abap.char(500);
      amtintext                   : abap.char(256);
      discval                     : abap.dec(13,2);
      freightval                  : abap.dec(13,2);
      packingval                  : abap.dec(13,2);
      totalamt                    : abap.dec(13,2);
      BankName                    : abap.char(150);
      StreetName                  : abap.char(150);
      CityName                    : abap.char(60);
      CustomerPaymentTermsName    : abap.char(200);
      IncotermsClassificationName : abap.char(200);
      ladingno                    : abap.char(20);
      ladingdt                    : sydate;
      counconsignee               : abap.char(300);
      custconsignee               : abap.char(200);
      custbuyer                   : abap.char(80);
      counbuyer                   : abap.char(300);
      amtsum                      : abap.dec(13,2);
      netduedate                  : sydate;
      transactionCurrency         : abap.cuky;
      var3                        : abap.char(75);
      proinv                      : abap.char(200);
      salesnoteref                : abap.char(200);
      _item                       : association [1..*] to ZI_COMM_ITEM_PRINT on $projection.BillingDocument = _item.Billingdocument;
      _item2                      : association [1..*] to ZV_QTYPACKTYPE on $projection.BillingDocument = _item2.comm_inv;
      _item1                      : association [1..1] to ZVTABPROP on $projection.BillingDocument = _item1.Billingdocument;
}
