@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors JE No'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_DEBT_JE_NO
  as select distinct from I_BillingDocument         as a
    inner join            I_OperationalAcctgDocItem as b on a.BillingDocument = b.BillingDocument
{
  key b.ClearingJournalEntry as JENo,
  key a.AccountingDocument   as DebtJENo
}
