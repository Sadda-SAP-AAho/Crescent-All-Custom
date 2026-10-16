@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function of FX Date'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_FX_DATE
returns
{
  key mandt        : mandt;
  key instructdate : abap.dats;
  key bankname     : abap.char(100);
      Bookdate     : abap.dats;


}

implemented by method
  zcl_fx_date=>GET_DATA;