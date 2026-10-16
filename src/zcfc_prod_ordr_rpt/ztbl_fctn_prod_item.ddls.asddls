@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table function for Production Order Item'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_PROD_ITEM
returns
{
  key mandt                     : mandt;
  key ProductionOrder           : abap.char( 12 );
  key ProductionOrderItem       : abap.char( 4 );
  key Product                   : matnr;
  key ProductionPlant           : abap.char( 4 );
      ProductionOrderType       : abap.char( 4 );
      PlannedTotalQty           : abap.dec( 19,6 );
      GoodsReceiptQty           : abap.dec( 19,6 );
      OpenYieldQuantity         : abap.dec( 19,6 );

}

implemented by method
  zcl_pp_prod_item=>get_data;