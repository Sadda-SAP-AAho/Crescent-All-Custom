@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: ' Open SO Report Details'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_OPENSODET1
  as select distinct from ZCDS_OPENSODET      as b
    left outer join       ZCDS_SOPENSO_DELQTY1 as z1 on  z1.ReferenceSDDocument     = b.SalesOrder
                                                    and z1.ReferenceSDDocumentItem = b.SalesOrderItem
{
  key b.SalesOrder,
  key b.SalesOrderItem,
  //key ScheduleLine,
      b.salesdate,
      b.CreationDate,
      b.Createdby,
      b.UpdateDate,
      b.reqdeldate,
      b.SalesContract,
      b.SoldToParty,
      b.TransactionCurrency,
      b.exchrate,
      b.CustomerPaymentTermsName,
      b.IncotermsClassification,
      b.Plant,
      b.PlantName,
      b.PurchaseOrderByCustomer,
      b.CustomerPurchaseOrderDate,
      b.CommittedDeliveryDate,
      b.UnderlyingPurchaseOrderItem,
      b.Product,
      b.SalesOrderItemText,
      b.MaterialByCustomer,
      b.BOM_Item,
      b.OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      b.OrderQuantity,
      //      holdorderstatus,
      b.holdstatus,
      b.contfreight,
      b.salesorderweight,
      b.ProfitCenter,
      b.custreqdeldate,
      b.YY1_CountryofDestinat_SDH,
      b.YY1_FinalDestination_SDH,
      b.YY1_PortofDischarge1_SDH,
      b.YY1_PortOfLoading1_SDH,
      b.SalesOrganization,
      b.DistributionChannel,
      b.CustomerName,
      b.SalesPersonName,
      //      ActualGoodsMovementDate,
      b.ConsumptionTaxCtrlCode,
      b.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      b.NetWeight,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      //      sum(delqty)       as delqty,
      z1.delivqty         as delqty,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      z1.balanceqty   as balanceqty,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      ( cast( ( z1.balanceqty )  as abap.dec(13,2) )  *
                cast(b.NetWeight as abap.dec(13,2)) )    as balancewt,
      b.unitprice,
      cast( b.unitprice * cast( z1.balanceqty  as abap.dec(13,2) ) as abap.dec(13,2)) as balancevaldc,
      cast(cast(b.unitprice * cast( z1.balanceqty  as abap.dec(13,2) ) as abap.dec(13,2) )  *
              cast( b.exchrate as abap.dec(5,2) ) as abap.dec(13,2) ) as balancevallc,
      b.AdditionalMaterialGroup1Name,
      b.pricetype,
      b.contractdate,
      b.materialpaintinfo,
      b.soholdstat,
      b.HoldbyMakt,
      b.SDDocumentReasonText,
      b.moc,
      b.ptnapp,
      b.pilotprdapp,
      b.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      b.stockqty,
      b.packinglist,
      b.Createdon,
      b.Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.qtysum,
      b.SalesDocumentRjcnReasonName,
      b.YY1_POEntryMailRecdDat_SDH,
      b.YY1_SOTransferMailRecd_SDH,
      b.production_plant
      

}

