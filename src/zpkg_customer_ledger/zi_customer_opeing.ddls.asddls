@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Opening Balance'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUSTOMER_OPEING
  with parameters
    @EndUserText.label: 'From Date'
    p_from_date : zde_date_va,
    @EndUserText.label: 'To Date'
    p_to_date   : zde_date_va,
    customer    : kunnr,
    p_company : bukrs
  as select from I_OperationalAcctgDocItem
{
  key $parameters.p_from_date          as postingdate,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(AmountInCompanyCodeCurrency) as amount
}
where
      FinancialAccountType = 'D'
  and Customer             = $parameters.customer
  and PostingDate          < $parameters.p_from_date
  and CompanyCode = $parameters.p_company
  and SpecialGLCode <> 'F'
  and AccountingDocumentType <> 'ZR'
  and AccountingDocumentType <> 'ZD'
group by
  CompanyCodeCurrency
