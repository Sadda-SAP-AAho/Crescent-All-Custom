@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Testing For FLTP value'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_TESTING_FLTP_VAL  as select from I_JournalEntryItem as a
    inner join   zdt_costingpl_pc   as b on a.ProfitCenter = b.prctr
    left outer join ZR_REJECTED_QTY_RATIO as c on a.OrderID = c.OrderID
{
  key  a.AccountingDocument,
  key  a.CompanyCode,
  key  a.FiscalYear,
  key  a.AccountingDocumentItem,
  key  concat( substring(a.PostingDate, 5, 2) , substring(a.PostingDate, 1, 4) ) as mmyyyy,
  key  b.prctrclub,
       a.CompanyCodeCurrency,
       case  
       when c.ratio is not null
       then
    ( cast(a.AmountInCompanyCodeCurrency as abap.dec( 15, 2 )) * cast(c.ratio as abap.dec(6, 3 ) ) ) 
    else cast(a.AmountInCompanyCodeCurrency as abap.dec(21,2) ) end as AmountInCompanyCodeCurrency
}
where
      a.GLAccount              = '0099901110'
  and a.Ledger                 = '0L'
  and a.SourceLedger           = '0L'
  and a.AccountingDocumentType = 'CO'
  and a.OrderID            is not initial
