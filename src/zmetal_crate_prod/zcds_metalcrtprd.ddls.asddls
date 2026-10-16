@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS  for Metal Crate Production'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_METALCRTPRD
  as select from    I_SalesOrder         as A
    left outer join I_SalesOrderItem     as B on A.SalesOrder = B.SalesOrder
    left outer join I_SalesDocumentItem  as bb on A.SalesOrder = bb.SalesDocument
                                                  and B.SalesOrderItem = bb.SalesDocumentItem
    left outer join I_ProductDescription as C on B.Product = C.Product
    left outer join I_SalesOrderScheduleLine as D on A.SalesOrder = D.SalesOrder
{
  key $session.client                 as mandt_1,
  key A.SalesOrder         as SalesOrdNo,
  key B.SalesOrderItem     as LineNumber,
  key B.Product            as ItemCode,
      A.SalesOrderDate     as SalesOrdDate,
      A.SoldToParty        as CustomerCode,
      C.ProductDescription as ItemName,
      D.OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      (D.ConfdOrderQtyByMatlAvailCheck - D.DeliveredQtyInOrderQtyUnit)  as Openqty,
      bb.MRPArea           as Plant,
      bb.Material

}
