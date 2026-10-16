@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table function for BOM Item'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_BOM_ITEMS

returns
{
  key mandt              : mandt;
  key plant              : werks_d;
  key material           : matnr;

}
implemented by method
  zcl_pp_bomitems=>get_data;