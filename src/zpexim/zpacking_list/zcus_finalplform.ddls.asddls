@EndUserText.label: 'Custom Entity For Final Packing List'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_FINALPLFORM_IMPL'
define custom entity ZCUS_FINALPLFORM

{
  key BillingDocument          : vbeln;
      doc_ref_id               : abap.char(200);
      pol                      : abap.char(100);
      pod                      : abap.char(100);
      coo                      : abap.char(100);
      cod                      : abap.char(100);
      cusmar                   : abap.char(100);
      descgoods                : abap.char(100);
      precarby                 : abap.char(30);
      por                      : abap.char(60);
      placedel                 : abap.char(100);
      vesselno                 : abap.char(30);
      contno                   : abap.char(200);
      PurchaseOrderByCustomer  : bstkd;
      CreationDate             : erdat;
      caddress1                : abap.char(100);
      caddress2                : abap.char(100);
      name                     : abap.char(75);
      gstin                    : abap.char(50);
      cinno                    : abap.char(50);
      iec                      : abap.char(50);
      Findes                   : abap.char(75);
      Carsealno                : abap.char(200);
      meins                    : meins;
      @Semantics.quantity.unitOfMeasure : 'meins'
      sumgrosswt               : abap.quan(13,3);
      @Semantics.quantity.unitOfMeasure : 'meins'
      sumnetwt                 : abap.quan(13,3);
      counconsignee            : abap.char(300);
      custconsignee            : abap.char(100);
      custbuyer                : abap.char(100);
      counbuyer                : abap.char(300);
      ShippingBill             : abap.char(20);
      ShippingBillDate         : abap.dats;
      Descgoods1               : abap.char(500);
      Descgoods2               : abap.char(500);
      CustomerPaymentTermsName : abap.char(200);
      ladingno                 : abap.char(20);
      var3                     : abap.char(75);
      sumqty                   : abap.char(20);
      remarks                  : abap.char(500);
      _item                    : association [1..*] to ZI_FINALPL_ITEM_PRINT on $projection.BillingDocument = _item.Billingdocument;
      _item2                   : association [1..*] to ZV_QTYPACKTYPE on $projection.BillingDocument = _item2.comm_inv;
      _item1                   : association [1..1] to ZVTABPROP1 on $projection.BillingDocument = _item1.Billingdocument;
}
