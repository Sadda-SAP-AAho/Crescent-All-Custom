@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zcds_valuecal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_valuecal1 as select from zcds_valuecal
{
    key BillingDocument,
    Value,
    Value + Value1 - ( Discount + Freight ) as Value1,
    Discount,
    Freight
}
