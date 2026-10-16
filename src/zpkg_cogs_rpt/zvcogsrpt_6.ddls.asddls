@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COGS Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVCOGSRPT_6

  as select from I_ProdCostEstCostCompRawDEX

{

  key  CostEstimate,
  key  CostingDate,
       Currency,
       cast( CostComponentCostField1Amt as abap.dec(21,2) )   as DirectMaterial,

       cast( CostComponentCostField3Amt as abap.dec(21,2) )   as Credits,

       cast( CostComponentCostField5Amt as abap.dec(21,2) )   as PackingPattern,

       cast( CostComponentCostField7Amt as abap.dec(21,2) )   as StoresSpares,

       cast( CostComponentCostField9Amt as abap.dec(21,2) )   as MaterialOverhead,

       cast( CostComponentCostField11Amt as abap.dec(21,2) )  as MouldingExpense,

       cast( CostComponentCostField13Amt as abap.dec(21,2) )  as FetlingExpense,

       cast( CostComponentCostField15Amt as abap.dec(21,2) )  as ElectricityExpense,

       cast( CostComponentCostField17Amt as abap.dec(21,2) )  as FabricationExpense,

       cast( CostComponentCostField23Amt as abap.dec(21,2) )  as StoresCost,

       cast( CostComponentCostField25Amt as abap.dec(21,2) )  as MachiningCharges,

       cast( CostComponentCostField27Amt as abap.dec(21,2) )  as MeltingCost,

       cast( CostComponentCostField29Amt as abap.dec(21,2) )  as FerroAlloyTreatment,

       cast( CostComponentCostField31Amt as abap.dec(21,2) )  as PatternCost,

       cast( CostComponentCostField33Amt  as abap.dec(21,2) ) as MachineCost,

       cast( CostComponentCostField35Amt as abap.dec(21,2) )  as PaintFinishExp
}

where
      CostIsInCtrlgAreaCrcy          is initial
  and IsCostComponentSplitLowerLevel is initial
