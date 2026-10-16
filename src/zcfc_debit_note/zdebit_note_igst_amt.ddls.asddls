@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debit Note Igst Amt'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDebit_Note_Igst_Amt 
  as select from I_OperationalAcctgDocItem
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key TaxItemAcctgDocItemRef,
      sum( cast( AmountInAdditionalCurrency1 as abap.dec(23,6) ) ) as AmountInAdditionalCurrency1
}
where
      TransactionTypeDetermination = 'JII'
  and AccountingDocumentItemType   = 'T'
group by
  CompanyCode,
  FiscalYear,
  AccountingDocument,
  TaxItemAcctgDocItemRef;
