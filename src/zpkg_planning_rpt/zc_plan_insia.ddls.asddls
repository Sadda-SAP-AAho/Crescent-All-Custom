@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Planning Report-INSIA'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_PLAN_INSIA
  as select from ZI_PLAN_INSIA
{
      @EndUserText.label: 'Plant'
      @Consumption.filter.mandatory: true
      @UI.hidden: true
  key plant,
      @EndUserText.label: 'Crescent Part Code'
  key Crescent_Part_Code,
      @EndUserText.label: 'CustCode'
      CusCode,
      @EndUserText.label: 'Foreign Name - FG'
      Foreign_Name_FG,
      @EndUserText.label: 'Unit Wt-Kg'
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      Unit_Wt,
      @EndUserText.label: 'Unit'
      WeightUnit,
      @EndUserText.label: 'Total Order'
      Total_Order,
      @EndUserText.label: 'FG on Hand Qty'
      FG_On_Hand_Qty,
      @EndUserText.label: 'Paint On Hand-Qty'
      Paint_On_Hand_Qty,
      @EndUserText.label: 'Grinding On Hand-Qty'
      Grinding_On_Hand_Qty,
      @EndUserText.label: 'Machining On Hand-Qty'
      Machining_On_Hand_Qty,
      @EndUserText.label: 'Casting On Hand-Qty'
      Casting_On_Hand_Qty
}
