@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PR_QTY
  as select distinct from I_PurchaseRequisitionItemAPI01 as a
    left outer join       I_Plant                        as b on a.Plant = b.Plant
{
  key a.Material,
  key a.Plant,
      a.BaseUnit,
      @Semantics.quantity.unitOfMeasure : 'BaseUnit'
      sum( a.RequestedQuantity )                          as PRQty,
      @Semantics.quantity.unitOfMeasure : 'BaseUnit'
      sum ( ( a.RequestedQuantity - a.OrderedQuantity ) ) as OpenPRQty
}

where
  a.IsDeleted is initial

group by
  a.Material,
  a.Plant,
  a.BaseUnit
