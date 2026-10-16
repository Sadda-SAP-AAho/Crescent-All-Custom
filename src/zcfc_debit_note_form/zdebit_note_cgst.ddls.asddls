@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debit Note Cgst Amt'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDEBIT_NOTE_CGST
  as select from I_OperationalAcctgDocItem
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key TaxItemAcctgDocItemRef,
      sum( cast( AmountInAdditionalCurrency1 as abap.dec(23,6) ) ) as AmountInAdditionalCurrency1
}
where
      TransactionTypeDetermination = 'JIC'
  and AccountingDocumentItemType   = 'T'
group by
  CompanyCode,
  FiscalYear,
  AccountingDocument,
  TaxItemAcctgDocItemRef;
