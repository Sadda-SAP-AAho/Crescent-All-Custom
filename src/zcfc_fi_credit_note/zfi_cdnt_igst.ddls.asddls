@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'IGST of FI Credit note'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_CDNT_IGST 

as select from I_OperationalAcctgDocItem
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key TaxItemAcctgDocItemRef,
      sum( cast( AmountInAdditionalCurrency1 as abap.dec(23,6) ) ) as AmountInAdditionalCurrency1
}
where
      TransactionTypeDetermination = 'JOI'
  and AccountingDocumentItemType   = 'T'
group by
  CompanyCode,
  FiscalYear,
  AccountingDocument,
  TaxItemAcctgDocItemRef;
