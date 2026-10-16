@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Max'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_ZMAXCASHDSC as select distinct from I_OperationalAcctgDocItem
{
  key AccountingDocument ,
  key FiscalYear,
  key CompanyCode,
  max(CashDiscount1Days) as CASHDISCOUNT1DAYS

 
 
}
group by AccountingDocument,
FiscalYear,
CompanyCode
