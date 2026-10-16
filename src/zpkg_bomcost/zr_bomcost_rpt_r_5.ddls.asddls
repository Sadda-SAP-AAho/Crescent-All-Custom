@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'TF for BOM Cost Report - Routing Seq'
define table function ZR_BOMCOST_RPT_R_5

returns
{
  key mandt                     : abap.clnt;
  key ProductionRoutingGroup    : abap.char(8);
  key ProductionRouting         : abap.char(2);
}
implemented by method
  zcl_routing_seq=>get_data;