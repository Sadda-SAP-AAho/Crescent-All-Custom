@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debit Note Total Price'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDebit_Note_Total_Price as select from I_JournalEntryItem
{
    key SourceLedger,
key CompanyCode,
key FiscalYear,
key AccountingDocument,
key LedgerGLLineItem,
key Ledger,
ReferenceDocument,
      TransactionCurrency as currency,
    cast(DebitAmountInBalanceTransCrcy as abap.dec(13,2)) as Debit_Amount,
     cast(CreditAmountInGlobalCrcy as abap.dec(13,2)) as Credit_Amount
}
