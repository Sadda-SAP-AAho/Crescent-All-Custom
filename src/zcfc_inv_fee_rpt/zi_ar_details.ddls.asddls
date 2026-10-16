@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'AR Invoice Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_AR_DETAILS
  as select distinct from I_BillingDocument         as a
    inner join            I_OperationalAcctgDocItem as b on a.BillingDocument = b.BillingDocument
    left outer join       I_Customer                as c on b.Customer = c.Customer


{
  key b.ClearingJournalEntry                                                                                                    as JENo,
  key a.BillingDocument,
      a.BillingDocumentDate,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.TotalNetAmount,
      a.TransactionCurrency,
      a.AccountingExchangeRate,
      cast( cast( a.TotalNetAmount as abap.dec(12,3) ) * cast( a.AccountingExchangeRate as abap.dec(12,3) ) as abap.dec(12,3) ) as InvValINR,
      b.Customer                                                                                                                as Customer,
      c.CustomerName                                                                                                            as CustName

}
