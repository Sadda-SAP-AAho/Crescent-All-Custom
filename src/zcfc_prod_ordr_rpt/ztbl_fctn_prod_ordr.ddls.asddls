@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table function for Production Order'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_PROD_ORDR

returns
{
  key mandt                  : mandt;
  key ProductionOrder        : abap.char( 12 );
  key Product                : matnr;
  key ProductionPlant        : abap.char( 4 );
      CreatedByUser          : abap.char( 12 );
      CreationDate           : abap.dats;
      LastChangedByUser      : abap.char( 12 );
      LastChangeDate         : abap.dats;
      ProductionOrderType    : abap.char( 4 );
      PlannedOrder           : abap.char( 10 );
      ProfitCenter           : abap.char( 10 );
      OrderActualReleaseDate : abap.dats;

}

implemented by method
  zcl_pp_prod_ordr=>get_data;