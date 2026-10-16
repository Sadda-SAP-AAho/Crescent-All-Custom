@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
@EndUserText.label: 'Interface View for COGS Report'
define root view entity ZI_COGSRPT

  with parameters
    p_begin : datum,
    p_end   : datum

  as select from ZVCOGSRPT_7( p_begin: $parameters.p_begin, p_end: $parameters.p_end )
{
      @EndUserText.label: 'Accounting Document Number'
  key AccountingDocument,
      @EndUserText.label: 'Fiscal Year'
  key FiscalYear,
      @EndUserText.label: 'Company Code'
  key CompanyCode,
      @EndUserText.label: 'Accounting Document Item'
  key AccountingDocumentItem,
      @EndUserText.label: 'Sold To Party'
      SoldToParty,
      @EndUserText.label: 'Original Reference Document'
      OriginalReferenceDocument,
      @EndUserText.label: 'PGI Number'
      PGINo,
      @EndUserText.label: 'PGI Item'
      PGIItem,
      @EndUserText.label: 'PGI Date'
      PGIDate,
      @EndUserText.label: 'GL Account'
      GLAccount,
      @EndUserText.label: 'GL Account Name'
      GLAccountName,
      @EndUserText.label: 'Profit Center'
      ProfitCenter,
      @EndUserText.label: 'Profit Center Name'
      ProfitCenterName,
      @EndUserText.label: 'Comapany Code Currency'
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Amount in Company Code Currency'
      AmountInCompanyCodeCurrency,
      @EndUserText.label: 'Delivery Document Number'
      DeliveryDocument,
      @EndUserText.label: 'Delivery Document Item'
      DeliveryDocumentItem,
      @EndUserText.label: 'GST Invoice Number'
      GSTInvoiceNumber,
      @EndUserText.label: 'Commercial Invoice Number'
      CommercialInvoiceNumber,
      @EndUserText.label: 'Product'
      Product,
      @EndUserText.label: 'Product Name'
      ProductName,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Quantity In Base Unit'
      QuantityInBaseUnit,
      @EndUserText.label: 'Material Base Unit'
      MaterialBaseUnit,
      @EndUserText.label: 'Weight Unit'
      WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      @EndUserText.label: 'Net Weight'
      NetWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      @EndUserText.label: 'Total Weight'
      TotalWeight,
      @EndUserText.label: 'Cost Estimate'
      CostEstimate,
      @EndUserText.label: 'Valuation Quantity Unit'
      ValuationQuantityUnit,
      @EndUserText.label: 'Costing Lot Size'
      CostingLotSize,
      @EndUserText.label: 'Costing Date'
      CostingDate,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Direct Cost Material'
      DirectMaterial,
      @EndUserText.label: 'Foundry Return'
      Credits,
      @EndUserText.label: 'Packing Pattern'
      PackingPattern,
      @EndUserText.label: 'Stores Spares'
      StoresSpares,
      @EndUserText.label: 'Material Overhead'
      MaterialOverhead,
      @EndUserText.label: 'Moulding Expense'
      MouldingExpense,
      @EndUserText.label: 'Fetling Expense'
      FetlingExpense,
      @EndUserText.label: 'Electricity Expense'
      ElectricityExpense,
      @EndUserText.label: 'Fabrication Expense'
      FabricationExpense,
      @EndUserText.label: 'Stores Cost'
      StoresCost,
      @EndUserText.label: 'Machining Charges'
      MachiningCharges,
      @EndUserText.label: 'Melting Cost'
      MeltingCost,
      @EndUserText.label: 'Ferro Alloy Treatment'
      FerroAlloyTreatment,
      @EndUserText.label: 'Pattern Cost'
      PatternCost,
      @EndUserText.label: 'Machine Cost'
      MachineCost,
      @EndUserText.label: 'Painting Finish Expense'
      PaintFinishExp

}
