@AbapCatalog.sqlViewName: 'ZPRODQTY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Order Qty'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PRODQTY
  as select distinct from I_ProductionOrder          as a
    inner join            I_ProductionOrderComponent as b on a.ProductionOrder = b.ProductionOrder
    left outer join       I_MaterialDocumentItem_2   as c on  b.ProductionOrder = c.OrderID
                                                          and b.ReservationItem = c.ReservationItem
{
  key a.ProductionOrder                            as ProdOrdrNo,
  key b.BillOfMaterialItemNumber                   as SlNo,
  key b.Material                                   as CompNo,
  key c.ReservationItem,
      b.BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      ( case when c.DebitCreditCode = 'S' then ( b.RequiredQuantity * (-1) )
             else b.RequiredQuantity end )         as CompPlanedQty,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      ( case when c.DebitCreditCode = 'S' then ( b.WithdrawnQuantity * (-1) )
             else b.WithdrawnQuantity end )        as CompIssuedQty,
      c.CompanyCodeCurrency                        as Currency,
      @Semantics.amount.currencyCode: 'Currency'
      ( case when c.DebitCreditCode = 'S' then ( c.TotalGoodsMvtAmtInCCCrcy * (-1) )
             else c.TotalGoodsMvtAmtInCCCrcy end ) as AmtinLocCurr

}
where
  a.ProductionOrderType = 'ZRWK'
