@ObjectModel.query.implementedBy: 'ABAP:ZCL_PATINV_IMPL'
@EndUserText.label: 'Custom Entity for Pattern Invoice'
define custom entity ZCUS_PATINV
{
  key BillingDocument           : vbeln_vl;
      DocumentReferenceID       : abap.char(16);
      BillingDocumentDate       : fkdat;
      caddress1                 : abap.char(100);
      caddress2                 : abap.char(100);
      caddress3                 : abap.char(100);
      name                      : abap.char(75);
      gstin                     : abap.char(50);
      cmobile                   : abap.char(20);
      var6                      : abap.char(100);
      customername              : abap.char(100);
      address                   : abap.char(200);
      bankname                  : abap.char(60);
      streetname                : abap.char(35);
      cityname                  : abap.char(35);                   
      
      
      _item                     : association [1..*] to ZCDS_PATINVITM on $projection.BillingDocument = _item.BillingDocument;
 }
