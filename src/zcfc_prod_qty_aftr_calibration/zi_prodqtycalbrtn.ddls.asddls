@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Qty after Calibration'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PRODQTYCALBRTN
  as select from ZI_PRODQTYCALBRTN_1
{
  key Material,
  key Material_Desc,
  key Plant,
      MOC,
      Customer,
      Calibration_Dt,
      Qtyperbox,
      WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      Unit_Wt,
      EntryUnit,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      cast ( Total_Qty as abap.dec( 15, 3 ) ) as Total_Qty,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      cast ( Total_Wt as abap.dec( 15, 3 ) )  as Total_Wt
}
