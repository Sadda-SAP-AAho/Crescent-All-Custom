@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'TF for BOM Cost Report - Routing'
define table function ZR_BOMCOST_RPT_R_2


returns {
  key mandt        : abap.clnt;
  key CostCenter   : kostl;
  key ActivityType : lstar;
  key costamt      : abap.dec(23,2);
  key factor       : abap.numc(5);
  
}
implemented by method zcl_bomcost_r=>get_data;