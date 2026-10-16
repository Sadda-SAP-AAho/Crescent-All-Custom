@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_INPUTREG13
  as select from ZR_INPUTREG12
{
  key AccountingDocument,
  key FiscalYear,
  key CompanyCode,
      sum( GLAccount ) as GLAccount
}
group by
  AccountingDocument,
  FiscalYear,
  CompanyCode
