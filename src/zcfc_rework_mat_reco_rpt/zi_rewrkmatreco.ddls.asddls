@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rework Material Reco Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_REWRKMATRECO
  as select distinct from ZI_REWRKMATRECO_1

{
  key ProdOrdrNo,
  key PlantCode as Plant,
  key SlNo   as Sl,
  key CompNo as Comp,
      OrdrActRelDate,
      CreatedBy,
      CreationDate,
      LastUptBy,
      LastUptDate,
      PlantCode,
      PlantName,
      ProfitCenterCode,
      ProfitCenterName,
      SlNo,
      CompNo,
      CompDesc,
      CompGrp,
      BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      CompPlanedQty,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      CompIssuedQty,
      WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      CompNetUnitWt,
      CompNetWt,
      MatlDocNo,
      MatlDocPostDt,
      Currency,
      @Semantics.amount.currencyCode: 'Currency'
      AmtinLocCurr,
      MovementType,
      DrCrIndiCator,
      GlCode,
      GLName
}
