@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Model 03'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRMODEL03 as select from ZRMODEL02
{
    key mmyyyy,
    key prctrclub,
    CompanyCodeCurrency,
      case 
    when ratio is null
    then cast(AmountInCompanyCodeCurrency as abap.dec( 21, 2 ) )
    else cast( (AmountInCompanyCodeCurrency * ratio ) as abap.dec( 21, 2) ) end as AmountInCompanyCodeCurrency
}
