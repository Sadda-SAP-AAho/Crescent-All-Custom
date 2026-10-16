@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for GSTR 2B Basic'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_GSTR_2B_BASIC
returns
{
  key mandt              : mandt;
  key GSTMonth           : abap.char(15);
  key rowno              : abap.char(10);
      AccountingDocument : abap.char(10);
}
implemented by method
  zcl_gstr_2b_je_no=>get_data;