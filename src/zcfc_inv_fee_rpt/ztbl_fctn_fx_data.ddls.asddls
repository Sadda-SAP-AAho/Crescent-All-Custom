@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function of FX Data'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_FX_DATA
returns
{
  key mandt        : mandt;
  key instructdate : abap.dats;
  key bankname     : abap.char(100);
  key contnoext    : abap.char(255);

}

implemented by method
  zcl_fx_data_1=>GET_DATA;