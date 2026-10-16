@EndUserText.label: 'for view I_PRODNROUTINGOPERATIONTP_2'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@AccessControl.authorizationCheck: #NOT_ALLOWED
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FUNC_ROUTING

returns
{
  key mandt                  : abap.clnt;
  key ProductionRoutingGroup : abap.char(8);
  key ProductionRouting      : abap.char(2);
  key WorkCenterInternalID   : abap.char(10);
  key WorkCenterTypeCode     : abap.char(8);
      StandardWorkQuantity1  : abap.dec(13,3);
      StandardWorkQuantity2  : abap.dec(13,3);

}
implemented by method
  zcl_prodrouting_det=>get_data;