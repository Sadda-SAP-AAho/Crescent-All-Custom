@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Contract-Report Test'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SALES_CON_RPT_TEST
  as select distinct from ZI_SALESCONTRACTRPT
{
  key  SalesContNo,
  key  SalesContractItem,
       SalesContDt,
       Plant,
       CustPONo,
       CustPODt,
       DelDate,
       CustCode,
       SalesPerson,
       PortofDischarge,
       ProfitCenter,
       MatCode,
       MatName,
       moc,
       HSN,
       BOM_Item,
       ptnapp,
       pilotprdapp,
       MatbyCust,
       Paint_Info,
       Rej_Reason,
       ItemWeightUnit,
       @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
       StdWt,
       TargetQuantityUnit,
       @Semantics.quantity.unitOfMeasure: 'TargetQuantityUnit'
       ContractQty,
       UoM,
       @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
       Contr_Wt,
       Bal_Qty,
       Bal_Wt,
       Revson_No,
       PayTerm,
       DelTerm
}
