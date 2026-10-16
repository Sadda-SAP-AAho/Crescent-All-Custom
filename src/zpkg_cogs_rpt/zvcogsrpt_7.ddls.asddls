@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COGS Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVCOGSRPT_7

  with parameters
    p_begin : datum,
    p_end   : datum

  as select from ZVCOGSRPT_2( p_begin: $parameters.p_begin, p_end: $parameters.p_end )
{

  key AccountingDocument,
  key FiscalYear,
  key CompanyCode,
  key AccountingDocumentItem,
      SoldToParty,
      OriginalReferenceDocument,
      PGINo,
      PGIItem,
      PGIDate,
      GLAccount,
      GLAccountName,
      ProfitCenter,
      ProfitCenterName,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,
      DeliveryDocument,
      DeliveryDocumentItem,
      GSTInvoiceNumber,
      CommercialInvoiceNumber,
      Product,
      ProductName,
      Plant,
      QuantityInBaseUnit,
      MaterialBaseUnit,
      WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      NetWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      TotalWeight,
      CostEstimate,
      ValuationQuantityUnit,
      CostingLotSize,
      CostingDate,
      Currency,
      division( DirectMaterial * QuantityInBaseUnit, CostingLotSize, 2 )      as DirectMaterial,
      division( Credits * QuantityInBaseUnit, CostingLotSize, 2 )             as Credits,
      division( PackingPattern * QuantityInBaseUnit, CostingLotSize, 2 )      as PackingPattern,
      division( StoresSpares * QuantityInBaseUnit, CostingLotSize, 2 )        as StoresSpares,
      division( MaterialOverhead * QuantityInBaseUnit, CostingLotSize, 2 )    as MaterialOverhead,
      division( MouldingExpense * QuantityInBaseUnit, CostingLotSize, 2 )     as MouldingExpense,
      division( FetlingExpense * QuantityInBaseUnit, CostingLotSize, 2 )      as FetlingExpense,
      division( ElectricityExpense * QuantityInBaseUnit, CostingLotSize, 2 )  as ElectricityExpense,
      division( FabricationExpense * QuantityInBaseUnit, CostingLotSize, 2 )  as FabricationExpense,
      division( StoresCost * QuantityInBaseUnit, CostingLotSize, 2 )          as StoresCost,
      division( MachiningCharges * QuantityInBaseUnit, CostingLotSize, 2 )    as MachiningCharges,
      division( MeltingCost * QuantityInBaseUnit, CostingLotSize, 2 )         as MeltingCost,
      division( FerroAlloyTreatment * QuantityInBaseUnit, CostingLotSize, 2 ) as FerroAlloyTreatment,
      division( PatternCost * QuantityInBaseUnit, CostingLotSize, 2 )         as PatternCost,
      division( MachineCost * QuantityInBaseUnit, CostingLotSize, 2 )         as MachineCost,
      division( PaintFinishExp * QuantityInBaseUnit, CostingLotSize, 2 )      as PaintFinishExp

}
