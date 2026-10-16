@EndUserText.label: 'concating po and dates using table func'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.sqlViewName: 'ZCONCAT_PO'
define view ZCDS__TBFUNC_CONCATPO
  as select from ZTBL_FUNC_CONCATPO
                 
{
  key deliverydocument,
      revision,
      zcuspodate
}
