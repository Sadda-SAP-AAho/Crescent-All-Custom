@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table function for BOM Details'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_BOM_DETAILS
returns
{
  key mandt                      : mandt;
  key BillOfMaterial             : abap.char( 8 );
  key Material                   : matnr;
  key BillOfMaterialItemNumber   : abap.char( 4 );
  key Plant                      : abap.char( 4 );
  key BillOfMaterialComponent    : matnr;
      ComponentDescription       : abap.char( 40 );
      BillOfMaterialItemCategory : abap.char( 4 );
      BillOfMaterialItemQuantity : abap.dec( 19,6 );
      BillOfMaterialItemUnit     : abap.char( 4 );

}

implemented by method
  zcl_pp_bom_details=>get_data;