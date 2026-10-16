@AccessControl.authorizationCheck: #NOT_REQUIRED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.clientSafe: true
@EndUserText.label: 'Table function for Prod Order Component'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FCTN_PROD_COMPONENT
returns
{
  key mandt                      : abap.clnt;
  key ProductionOrder            : abap.char( 12 );
  key Reservation                : abap.char( 10 );
  key ReservationItem            : abap.char( 4 );
  key BillOfMaterialInternalID   : abap.char( 8 );
  key BillOfMaterialItemNumber   : abap.char( 4 );
  key Material                   : matnr;
  key Plant                      : abap.char( 4 );
      StorageLocation            : abap.char( 4 );
      MaterialGroup              : abap.char( 4 );
      ReservationIsFinallyIssued : abap.char( 1 );
      RequiredQuantity           : abap.dec( 19,6 );
      WithdrawnQuantity          : abap.dec( 19,6 );
      WithdrawnQuantityAmount    : abap.dec( 19,6 );
}
implemented by method
  zcl_pp_prod_comp=>get_data;