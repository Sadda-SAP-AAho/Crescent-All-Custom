@ObjectModel.query.implementedBy: 'ABAP:ZCL_DOMDRAFTPL_IMPL'
@EndUserText.label: 'Draft Packing List'
define custom entity ZCUS_DOMDRAFTPL

{
  key DeliveryDocument              : vbeln_vl;
  key Revision                      : abap.numc(3);
      PurchaseOrderByCustomer       : bstkd;
      CustomerPurchaseOrderDate     : sydate;
//    Streetname                    : abap.char(100);
//    Cityname                      : abap.char(25);
//    PostalCode                    : abap.char(8);
//    Country                       : abap.char(30);
//    CustomerName                  : abap.char(75);
      IncotermsClassification       : abap.char(3);
      caddress1                     : abap.char(100);
      caddress2                     : abap.char(100);
      name                          : abap.char(50);
      address                       : abap.char(300);
      addressbp                     : abap.char(300);
      customernamesh                : abap.char(70);
      customernamebp                : abap.char(70);
      iec                           : abap.char(20);
      contactp                      : abap.char(20);
      contactn                      : abap.char(10);
      pkgtyp                        : abap.char(15);
      var3                          : abap.char(50);
      customer1                     : abap.char(20);
      customer                      : abap.char(20);
      counbuyer                     : abap.char(30);
      counconsignee                 : abap.char(30);
      remarks                       : abap.char(500);

      _item                     : association [1..*] to ZCDS_TBLFUNC_ITMPRNT on  $projection.DeliveryDocument = _item.DeliveryDocument
                                                                      and $projection.Revision         = _item.Revision;
      _item1                    : association [1..*] to ZV_DOMDPL_QTY on  $projection.DeliveryDocument = _item1.delivery
                                                                      and $projection.Revision         = _item1.revision;
      _item2                    : association [1..*] to ZCDS_CONCATPO on  $projection.DeliveryDocument = _item2.DeliveryDocument
                                                                      and $projection.Revision = _item2.revision;
}
