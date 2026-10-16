@ObjectModel.query.implementedBy: 'ABAP:ZCL_DRAFTPL_IMPL'
@EndUserText.label: 'Draft Packing List'
define custom entity ZCUS_DRAFTPL

{
  key DeliveryDocument          : vbeln_vl;
  key Revision                  : abap.numc(3);
      pol                       : abap.char(100);
      pod                       : abap.char(100);
      coo                       : abap.char(100);
      cod                       : abap.char(100);
      cusmar                    : abap.char(100);
      descgoods                 : abap.char(200);
      descgoods1                : abap.char(200);
      precarby                  : abap.char(30);
      por                       : abap.char(60);
      placedel                  : abap.char(100);
      vesselno                  : abap.char(30);
      contno                    : abap.char(200);
      PurchaseOrderByCustomer   : bstkd;
      PURCHASEORDERITEM : posex;
      CustomerPurchaseOrderDate : sydate;
      CreationDate              : erdat;
      IncotermsClassification   : abap.char(3);
      Incotermstransferlocation : abap.char(50);
      caddress1                 : abap.char(100);
      caddress2                 : abap.char(100);
      caddress3                 : abap.char(100);
      name                      : abap.char(75);
      iec                       : abap.char(25);
      customername              : abap.char(100);
      address                   : abap.char(300);
      var3                      : abap.char(50);
      textfield1                : abap.char(500);
      textfield2                : abap.char(500);
      customer1                 : abap.char(20);
      customer                  : abap.char(20);
      counbuyer                 : abap.char(30);
      counconsignee             : abap.char(30);
      buyeraddress              : abap.char(300);
      salesnoteref              : abap.char(100);
      crdate                    : erdat;
      BillingDocument           : abap.char(16);
      DocumentReferenceID       : abap.char(16);
      remarks                   : abap.char(500);
      zcuspodate                : abap.char(200);  

      _item                     : association [1..*] to ZI_DRAFTPL_PRINT on  $projection.DeliveryDocument = _item.DeliveryDocument
                                                                         and $projection.Revision         = _item.Revision;
      _item1                    : association [1..*] to ZVDRAFTQTY_CR on  $projection.DeliveryDocument = _item1.delivery
                                                                      and $projection.Revision         = _item1.revision;
      _item2                    : association [1..*] to ZCDS_CONCATPO on  $projection.DeliveryDocument = _item2.DeliveryDocument
                                                                      and $projection.Revision = _item2.revision;
}
