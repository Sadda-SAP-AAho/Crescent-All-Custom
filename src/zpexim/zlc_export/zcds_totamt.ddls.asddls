@AbapCatalog.sqlViewName: 'ZCDS_TOT'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View For Total Amount'
define view ZCDS_TOTAMT
  as select from ZCDS_SO_DETAILS 
  {
    key SalesOrder,
    key ( SUM_TAX + TotalNetAmount ) as tot_amt
  }
