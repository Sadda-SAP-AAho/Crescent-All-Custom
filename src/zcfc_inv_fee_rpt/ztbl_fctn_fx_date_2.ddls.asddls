@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function of FX Date-2'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_FX_DATE_2
returns
{
  key mandt        : mandt;
  key remarks   : abap.char(255);
      Bookdate     : abap.dats;


}

implemented by method
  zcl_fx_date_2=>GET_DATA;