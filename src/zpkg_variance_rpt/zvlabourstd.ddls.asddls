@AbapCatalog.sqlViewName: 'ZZVLABOURSTD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Labour STD'
@Metadata.ignorePropagatedAnnotations: true
define view ZVLABOURSTD
  as select distinct from I_JournalEntryItem as a
    inner join            zdt_costingpl_pc          as b on a.ProfitCenter = b.prctr
//    left outer join ZR_REJECTED_QTY as c on a.OrderID = c.OrderID
    
{
  key  a.AccountingDocument,
  key  a.CompanyCode,
  key  a.FiscalYear,
  key  a.AccountingDocumentItem,
  key  concat( substring(a.PostingDate, 5, 2) , substring(a.PostingDate, 1, 4) ) as mmyyyy,
  key  b.prctrclub,
    key a.OrderID,
       CompanyCodeCurrency,
       cast(a.AmountInCompanyCodeCurrency as abap.dec( 15,2 ) ) as AmountInCompanyCodeCurrency,
       cast( a.Quantity as abap.dec( 21, 3 )) as quantity
}
where
  (
      a.GLAccount = '0099901860'
  )
  and a.OrderID is not initial
  and a.AccountingDocumentType = 'CO'
