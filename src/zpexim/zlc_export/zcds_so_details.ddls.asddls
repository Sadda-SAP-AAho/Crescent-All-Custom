@AbapCatalog.sqlViewName: 'ZCDS_SO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO Details for LC'

define view ZCDS_SO_DETAILS
  as select from    I_SalesOrder as a
    left outer join I_Customer           as b on a.SoldToParty = b.Customer
    left outer join I_CompanyCode        as d on a.BillingCompanyCode = d.CompanyCode
    left outer join I_SalesOrderItem     as c on a.SalesOrder = c.SalesOrder 

{
  key a.SalesOrder,
      a.TransactionCurrency,
      a.SalesOrganization,
      a.TotalNetAmount,
      a.SoldToParty,
      b.CustomerFullName,
      c.Plant,
      d.CompanyCode,
     sum( c.TaxAmount ) as SUM_TAX
     
}
group by a.SalesOrder,a.SalesOrganization,a.TransactionCurrency,a.TotalNetAmount,a.SoldToParty,
         d.CompanyCode,b.CustomerFullName,c.Plant
