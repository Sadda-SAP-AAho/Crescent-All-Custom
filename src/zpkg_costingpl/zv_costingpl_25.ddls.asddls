@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_25

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from ZV_COSTINGPL( p_begin:$parameters.p_begin , p_end:$parameters.p_end )
{
  key CommercialInvoiceNumber,
  key CommercialInvoiceItemNumber,
  key AccountingDocNo,
  key CompanyCode,
  key FiscalYear,
      AssignmentReference,
      InvoiceType,
      BillingDocumentDate,
      Plant,
      PatternInd,
      ShipmentLocation,
      Customer,
      ShippingType,
      ResponsibleEmployee,
      CustomerReferenceNumber,
      DeliveryDocument,
      DeliveryDocumentItem,
      DeliveryDate,
      PackingListNo,
      SalesOrder,
      SalesOrderItem,
      SalesOrderDate,
      ExchangeRateSalesOrder,
      Product,
      ProductDescription,
      ProfitCenter,
      ProfitCenterLongName,
      NetDueDate,
      CreditDays,
      GLAccount,
      GLAccountName,
      RefOrder,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      BillingQuantity,
      BillingQuantityUnit,
      TransactionCurrency,
      AccountingExchangeRate,
      ValueinDC,
      Discount,
      ValueinCC,
      DiscountinCC,
      WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      MaterialNetWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      ItemNetWeight,
      TotalNetWeight,
      Currency,
      MetalCostBM,
      StandardPrice,
      FumigationCharges,
      ContainerFreight,
      ExcelloDocumentPortCharges,
      THCCharges,
      RadiationChecking,
      InspectionCharges,
      FreightUSD,
      ECGCPREMIUMRATE,
      ShortRelisationCharges,
      CreditPeriodCharges,
      BankAdvCharges,
      CommissionCharges,
      ClaimagainstDamagedMaterials,
      VariancePerKg,
      FreightreceivedAmount,
      PatternSale,

      //case when ItemNetWeight <> 0 then
      case when MaterialNetWeight <> 0 then
      // cast( division( cast( StandardPrice * BillingQuantity as abap.dec(23,2) ), cast( ItemNetWeight as abap.dec(15,3) ), 2 ) as abap.dec(31,2) )
      cast( division( cast( StandardPrice as abap.dec(23,2) ), cast( MaterialNetWeight as abap.dec(15,3) ), 2 ) as abap.dec(31,2) )
      else 0 end                                                                             as TotalCost,


      cast( FumigationCharges + ContainerFreight + ExcelloDocumentPortCharges + THCCharges + RadiationChecking +
      InspectionCharges + FreightUSD + ECGCPREMIUMRATE + ShortRelisationCharges + CreditPeriodCharges +
      BankAdvCharges + CommissionCharges + ClaimagainstDamagedMaterials  as abap.dec(23,2) ) as TotalSellingExp,

      case when ItemNetWeight <> 0 then
      coalesce( division( cast( ValueinCC as abap.dec(23,2) ), cast( ItemNetWeight as abap.dec(15,3) ), 2 ), 0 )
      else 0 end                                                                             as ordervalueasperorder,

      case when ItemNetWeight <> 0 then
      coalesce( division( ValueDiff, cast( ItemNetWeight as abap.dec(15,3) ), 2 ), 0 )
      else 0 end                                                                             as SalesOrderValueKg

}
