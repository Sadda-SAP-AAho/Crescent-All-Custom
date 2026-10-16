@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function of FX Data-2'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_FX_DATA_2
returns
{
  key mandt     : mandt;
  key remarks   : abap.char(255);
  key contnoext : abap.char(255);

}

implemented by method
  zcl_fx_data_2=>GET_DATA;