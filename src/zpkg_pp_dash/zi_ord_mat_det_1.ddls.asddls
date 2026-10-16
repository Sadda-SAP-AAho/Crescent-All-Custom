@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Details against Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ORD_MAT_DET_1 
as select from I_ManufacturingOrderItem as a
inner join I_MfgOrderWithStatus as b on b.ManufacturingOrder = a.ManufacturingOrder 
                                    and b.OrderIsTechnicallyCompleted <> 'X' 
                                    and b.OrderIsDeleted <> 'X'
                                    and b.OrderIsClosed <> 'X'
                                    and b.OrderIsMarkedForDeletion <> 'X' 
{
    key a.ManufacturingOrder,
    key a.Product,
    key a.ProductionPlant,
    @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
    sum( a.MfgOrderItemOpenYieldQty  ) as OpenYieldQuantity,
    a.ProductionUnit
    
}
where a.ManufacturingOrderCategory = '10' and a.OrderIsReleased = 'X' 
and a.Product is not initial
group by
a.ManufacturingOrder,
a.Product,
a.ProductionPlant,
a.ProductionUnit
