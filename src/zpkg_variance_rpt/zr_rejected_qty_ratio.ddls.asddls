@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Qty Ratio'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_REJECTED_QTY_RATIO
  as select  distinct from    ZR_YEILD_QTY    as a
  left outer join ZR_REJECTED_QTY as b on a.OrderID = b.OrderID
  
{
  key a.OrderID,
  cast( ( 1- cast( ( b.quantity / a.quantity ) as abap.dec(23,3) ) ) as abap.dec( 21,2) )  as ratio
}
