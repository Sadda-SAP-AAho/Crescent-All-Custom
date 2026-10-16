@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function of JE Details'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_JE_DETAILS
returns
{
  key mandt           : mandt;
  key CompCode        : abap.char(4);
  key FY              : abap.char(4);
  key JENo            : abap.char(10);
      GLAccount       : abap.char(10);
      RowNo           : abap.int4;
}
implemented by method
  zcl_je_details=>get_data;