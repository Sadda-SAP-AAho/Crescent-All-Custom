@EndUserText.label: 'Table Function For CDS'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@AccessControl.authorizationCheck: #NOT_ALLOWED
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FUNC_BILLOFOP

returns
{
  key mandt                     : abap.clnt;
  key ActivityType              : abap.char(6);
  key CostCenter                : abap.char(10);
      Currency                  : waers;
      CostRateFixedAmount       : abap.dec(23,2);
      ValidityStartDate         : datum;
      ValidityEndDate           : datum;
}
implemented by method
  zcl_boop_det=>get_data;