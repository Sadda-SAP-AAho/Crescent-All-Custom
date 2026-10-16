@AbapCatalog.sqlViewName: 'ZCDS_FIN'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for additional binding'
define view ZCDS_FINAL
  as select from  ZCDS_SO_DETAILS as a
  inner join  ZCDS_TOTAMT as b on a.SalesOrder = b.SalesOrder
  {
    key a.SalesOrder,
        a.TransactionCurrency,
        b.tot_amt
  }
  
