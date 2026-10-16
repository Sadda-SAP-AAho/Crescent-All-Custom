@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Aging'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_VEND_AGING_1
  as select distinct from I_OperationalAcctgDocItem
{
  AccountingDocument,
  FiscalYear,
  CompanyCode,
  max( ProfitCenter ) as ProfitCenter
}
where
      DebitCreditCode            = 'H'
  and AccountingDocumentType     = 'KG'
  and AccountingDocumentItemType is initial
  and FinancialAccountType       = 'S'
  and ProfitCenter               is not initial
  and GLAccount                  like '004%'
group by
  AccountingDocument,
  FiscalYear,
  CompanyCode
union select distinct from I_OperationalAcctgDocItem
{
  AccountingDocument,
  FiscalYear,
  CompanyCode,
  max( ProfitCenter ) as ProfitCenter
}
where
      DebitCreditCode            = 'S'
  and AccountingDocumentType     = 'RE'
  and AccountingDocumentItemType = 'W'
  and FinancialAccountType       = 'S'
  and ProfitCenter               is not initial
group by
  AccountingDocument,
  FiscalYear,
  CompanyCode  
union select distinct from I_OperationalAcctgDocItem
{
  AccountingDocument,
  FiscalYear,
  CompanyCode,
  max( ProfitCenter ) as ProfitCenter
}
where
      DebitCreditCode            = 'S'
  and AccountingDocumentType     = 'KR'
  and AccountingDocumentItemType is initial
  and FinancialAccountType       = 'S'
  and ProfitCenter               is not initial
  and GLAccount                  like '004%'
group by
  AccountingDocument,
  FiscalYear,
  CompanyCode
union select distinct from I_OperationalAcctgDocItem
{
  AccountingDocument,
  FiscalYear,
  CompanyCode,
  max( ProfitCenter ) as ProfitCenter
}
where
      DebitCreditCode            = 'S'
  and AccountingDocumentType     = 'KZ'
  and AccountingDocumentItemType is initial
  and FinancialAccountType       = 'K'
  and ProfitCenter               is not initial
group by
  AccountingDocument,
  FiscalYear,
  CompanyCode    
union select distinct from I_OperationalAcctgDocItem
{
  AccountingDocument,
  FiscalYear,
  CompanyCode,
  max( ProfitCenter ) as ProfitCenter
}
where
      ( AccountingDocumentType     <> 'KG' and
        AccountingDocumentType     <> 'RE' and
        AccountingDocumentType     <> 'KR' and
        AccountingDocumentType     <> 'KZ' )    
  and AccountingDocumentItemType is initial
  and FinancialAccountType       = 'S'
  and ProfitCenter               is not initial
group by
  AccountingDocument,
  FiscalYear,
  CompanyCode  
