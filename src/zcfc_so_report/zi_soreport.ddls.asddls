@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Sales Order Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SOREPORT
  as select distinct from ZCDS_OPENSODET1

{
  key SalesOrder,
  key SalesOrderItem,
      salesdate,
      CreationDate,
      Createdby,
      reqdeldate,
      SalesContract,
      SoldToParty,
      TransactionCurrency,
      exchrate,
      CustomerPaymentTermsName,
      IncotermsClassification,
      Plant,
      PlantName,
      //      pilotprdapp,
      //      ptnapp,
      PurchaseOrderByCustomer,
      CustomerPurchaseOrderDate,
      CommittedDeliveryDate,
      UnderlyingPurchaseOrderItem,
      Product,
      SalesOrderItemText,
      MaterialByCustomer,
      BOM_Item,
      OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      OrderQuantity,
      ProfitCenter,
      custreqdeldate,
      YY1_CountryofDestinat_SDH,
      YY1_FinalDestination_SDH,
      YY1_PortofDischarge1_SDH,
      YY1_PortOfLoading1_SDH,
      SalesOrganization,
      DistributionChannel,
      CustomerName,
      SalesPersonName,
      ConsumptionTaxCtrlCode,
      WeightUnit,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      NetWeight,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      delqty,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      balanceqty,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      balancewt,
      //      holdorderstatus,
      holdstatus,
      contfreight,
      salesorderweight,
      unitprice,
      balancevaldc,
      balancevallc,
      AdditionalMaterialGroup1Name,
      pricetype,
      contractdate,
      materialpaintinfo,
      soholdstat,
      HoldbyMakt,
      SDDocumentReasonText,
      moc,
      ptnapp,
      pilotprdapp,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      stockqty,
      packinglist,
      Createdon,
      Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      qtysum,
      SalesDocumentRjcnReasonName,
      YY1_POEntryMailRecdDat_SDH,
      YY1_SOTransferMailRecd_SDH,
      production_plant

}

//where SalesDocumentRjcnReasonName is null
