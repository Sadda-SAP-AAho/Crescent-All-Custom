@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'BOM-Item'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_BOM_ITM

returns
{
  key mandt                   : mandt;
  key BillOfMaterial          : abap.char(8);
  key BillOfMaterialComponent : matnr;
      ProdOrderIssueLocation  : abap.char(4);

}

implemented by method
  zcl_bom_itm=>get_data;