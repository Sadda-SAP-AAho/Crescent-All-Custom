@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVMELTLOSSACTIVITY
  as select from I_JournalEntryItem as a
    inner join   zdt_costingpl_pc   as b on a.ProfitCenter = b.prctr
//     left outer join ZR_REJECTED_QTY as c on a.OrderID = c.OrderID
{
  key  a.AccountingDocument,
  key  a.CompanyCode,
  key  a.FiscalYear,
  key  a.AccountingDocumentItem,
  key  concat( substring(a.PostingDate, 5, 2) , substring(a.PostingDate, 1, 4) ) as mmyyyy,
  key  b.prctrclub,
  key a.OrderID,
       a.CompanyCodeCurrency,
       cast(a.AmountInCompanyCodeCurrency as abap.dec( 15,2 ) ) as AmountInCompanyCodeCurrency,
      cast( a.Quantity as abap.dec( 21, 3 )) as quantity
//       cast( 1 - ( cast(c.quantity as abap.dec( 15, 2 ) ) /  cast(a.Quantity as abap.dec( 15, 2 ) )) as abap.dec(6,2) ) as ratio
    
}
where
      a.GLAccount              = '0099901110'
  and a.Ledger                 = '0L'
  and a.SourceLedger           = '0L'
  and a.AccountingDocumentType = 'CO'
  and a.OrderID                is not initial
