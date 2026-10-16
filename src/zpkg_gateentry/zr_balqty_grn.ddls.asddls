@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GRN Quantities'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BALQTY_GRN 
       as select from  I_MaterialDocumentItem_2 as a
{
  key a.PurchaseOrder     as Ebeln,
  key a.PurchaseOrderItem as Ebelp,
      cast (
      sum( case when ( a.GoodsMovementType = '102' or a.GoodsMovementType = '122' or a.GoodsMovementType = '161' )
                then a.QuantityInBaseUnit 
                else -1 * a.QuantityInBaseUnit end  )  as abap.dec( 13, 3 ) ) as reve_qty


}

where a.PurchaseOrder is not initial
and   ( a.GoodsMovementType = '102' or a.GoodsMovementType = '122' or a.GoodsMovementType = '123' or
        a.GoodsMovementType = '161' or a.GoodsMovementType = '162' )
group by a.PurchaseOrder,
         a.PurchaseOrderItem

    
