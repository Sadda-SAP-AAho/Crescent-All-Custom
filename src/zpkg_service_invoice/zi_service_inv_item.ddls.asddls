@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface ~ Service Invoice Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SERVICE_INV_ITEM

  as select from    I_OperationalAcctgDocItem as a

    inner join      I_JournalEntry            as c on  c.AccountingDocument = a.AccountingDocument
                                                   and c.FiscalYear         = a.FiscalYear

    left outer join ZV_IGST_SUM               as b on a.AccountingDocument = b.InvoiceNo
                                                   and a.TaxItemAcctgDocItemRef = b.TaxItemAcctgDocItemRef    

  association to parent ZI_SERVICE_INV_HEAD as _Head on $projection.InvoiceNo = _Head.InvoiceNo
                                                    and $projection.FiscalYear = _Head.FiscalYear


{
  key   a.AccountingDocument                                                                                                                                                         as InvoiceNo,
  key   a.AccountingDocumentItem                                                                                                                                                     as Item,
  key   a.FiscalYear,
        a.DocumentItemText                                                                                                                                                           as Description,
        a.IN_HSNOrSACCode                                                                                                                                                            as HSNCode,
        a.TransactionCurrency                                                                                                                                                        as UOM,
        // @Semantics: { amount : {currencyCode: 'UOM'} }
        cast(   abs( a.AmountInTransactionCurrency ) as   abap.dec( 23 , 2 ) )                                                                                                       as Amount,
        // @Semantics: { amount : {currencyCode: 'UOM'} }
        cast( abs( b.IGSTAmount )    as   abap.dec( 23 , 2 ) )                                                                                                                       as IGSTAmount,
        cast( abs(( coalesce(cast (b.IGSTAmount as abap.dec(23,2) ),0))  +  abs(coalesce( cast( a.AmountInTransactionCurrency as abap.dec(23,2) ) ,0 ))   ) as  abap.dec( 23 , 2 ) ) as Total,
        _Head
}
where
      a.FinancialAccountType       =  'S'
  and a.AccountingDocumentItemType <> 'T'
  and c.AccountingDocumentType     =  'DR'
