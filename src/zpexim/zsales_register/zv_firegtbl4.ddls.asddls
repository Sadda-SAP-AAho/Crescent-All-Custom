@EndUserText.label: 'Table Function'
@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZV_FIREGTBL4
returns
{
  key mandt              : mandt;
  key AccountingDocument : abap.char(10);
  key FiscalYear         : abap.char(4);
  key CompanyCode        : abap.char(4);
      Description        : abap.char(500);
}
implemented by method
  zcl_xblnr_rpt=>get_data;