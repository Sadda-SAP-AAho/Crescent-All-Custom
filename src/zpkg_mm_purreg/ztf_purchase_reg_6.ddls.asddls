@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for MIGO WBS Element'
define table function ZTF_PURCHASE_REG_6


returns
{
  key mandt                : abap.clnt;
  key WBSElementInternalID : abap.numc(8);
      WBSElementExternalID : abap.char(24);
      WBSDescription       : abap.char(40);

}
implemented by method
  Zcl_pur_wbs=>get_data;