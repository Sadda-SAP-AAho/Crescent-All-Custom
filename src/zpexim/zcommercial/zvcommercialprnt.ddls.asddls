@ObjectModel.query.implementedBy: 'ABAP:ZCL_COMM_IMPL'
@EndUserText.label: 'Commercial Print'
define custom entity ZVCOMMERCIALPRNT

{
      //  key id :   sysuuid_x16 ;
  key Billingdocument     : vbeln;
      doc_Ref             : vbeln ;
      CreationDate        : sydate;
      CreationTime        : timn;
      caddress1           : abap.char(100);
      caddress2           : abap.char(100);
      caddress3           : abap.char(100);
      name                : abap.char(75);
      BillingQuantityUnit : meins;
      _item               : association [1..*] to ZVCOMMITEMPRNT on $projection.Billingdocument = _item.BillingDocument;


}
