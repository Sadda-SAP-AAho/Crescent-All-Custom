@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'BOM-Header'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_BOM_HEAD

returns
{
  key mandt                   : mandt;
  key BillOfMaterial          : abap.char(8);
  key plant                   : abap.char(4);
  key Material                : matnr;
      

}

implemented by method
  zcl_bom_head=>get_data;