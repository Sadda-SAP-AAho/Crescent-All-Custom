@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'ZTBL_FCTN_BOM_COMP'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_BOM_COMP
returns
{
  key mandt                   : mandt;
  key plant                   : werks_d;
  key BillOfMaterialComponent : matnr;

}
implemented by method
  zcl_pp_bom_comp=>get_data;