@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cost Center-Profit Center Combination'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_CC_PC_COMB
  as select distinct from ZI_TmgTableForCCPC as a
{
  key a.Compcode                                       as CompanyCode,
  key substring( a.Cccode, 5, length( a.Cccode ) - 4 ) as CostCenter,
  key a.Ccname                                         as CostCenterName,
  key cast( a.Pccode as abap.char(10) )                as ProfitCenter,
  key a.Pcname                                         as ProfitCenterName

}
