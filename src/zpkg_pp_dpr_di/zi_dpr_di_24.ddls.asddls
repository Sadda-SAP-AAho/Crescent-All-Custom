@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR DI - Excess Weight'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_DI_24 
as select from ZI_DPR_DI_23 
{
    shpflrdt,
    dept,
    sum( case when excesswt > 0 then excesswt else 0 end ) as excesswt
}
group by
shpflrdt,
dept
