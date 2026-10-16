@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Fund Limit'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BANK_FUND_LIMIT_1
  as select distinct from ZR_BANK_FUND_LIMIT as a

{

  key a.Bukrs,
  key a.Hbkid,
  key a.Hktid,
  key a.loantype,
      a.CompanyCodeCurrency,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      sum( a.AmountInCompanyCodeCurrency ) as AmountInCompanyCodeCurrency


}
group by
  a.Bukrs,
  a.Hbkid,
  a.Hktid,
  a.loantype,
  a.CompanyCodeCurrency
