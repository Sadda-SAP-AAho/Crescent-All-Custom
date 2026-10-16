@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_26

  as select distinct from I_OperationalAcctgDocItem as a
{

  key a.AccountingDocument,
  key a.FiscalYear,
  key a.CompanyCode,
      a.ProfitCenter

}

where
  ProfitCenter is not initial
