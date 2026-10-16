@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Matrial Order Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ORD_MAT_DET
as select from ZI_ORD_MAT_DET_1 as a
left outer join ZI_MAT_ORD_DASH_DET as b on a.ManufacturingOrder = b.Prodord and a.ProductionPlant = b.Plant and a.Product = b.Matnr
{
    key a.ManufacturingOrder,
    key a.Product,
    key a.ProductionPlant,
    @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
    ( case when a.OpenYieldQuantity is not initial and b.Qty is not initial
           then ( cast( a.OpenYieldQuantity as abap.quan( 13, 3 ) ) - ( cast( b.Qty as abap.quan( 13, 3 ) ) - cast( b.Apqty as abap.quan( 13, 3 ) ) ) )
           when a.OpenYieldQuantity is not initial then cast( a.OpenYieldQuantity as abap.quan( 13, 3 ) )
           else cast( 0 as abap.quan( 13, 3 ) ) end ) as OpenYieldQuantity,
    a.ProductionUnit
    
}

