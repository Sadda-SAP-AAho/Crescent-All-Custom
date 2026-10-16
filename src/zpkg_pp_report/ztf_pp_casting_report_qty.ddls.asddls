@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for Daily Prod Casting Report Quantity'
define table function ZTF_PP_CASTING_REPORT_QTY

returns
{
  key mandt                     : abap.clnt;
  key ProductionRoutingGroup    : abap.char(8);
  key WorkCenterInternalID      : abap.numc(8);
      StandardWorkQuantity1     : abap.dec(13,3);
      StandardWorkQuantityUnit1 : meins;
      StandardWorkQuantity2     : abap.dec(13,3);
      StandardWorkQuantityUnit2 : meins;
      StandardWorkQuantity3     : abap.dec(13,3);
      StandardWorkQuantityUnit3 : meins;
      StandardWorkQuantity4     : abap.dec(13,3);
      StandardWorkQuantityUnit4 : meins;
      StandardWorkQuantity5     : abap.dec(13,3);
      StandardWorkQuantityUnit5 : meins;
      StandardWorkQuantity6     : abap.dec(13,3);
      StandardWorkQuantityUnit6 : meins;

}
implemented by method
  ZCL_PP_CASTING_REPORT_QTY=>get_data;