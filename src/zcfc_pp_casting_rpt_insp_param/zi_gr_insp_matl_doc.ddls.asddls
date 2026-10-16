@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GR & Quality Material Document Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GR_INSP_MATL_DOC

  as select distinct from ZI_GR_MAT_DOC_DETAILS   as a

    left outer join       ZI_INSP_MAT_DOC_DETAILS as b on  a.InspectionLot = b.InspectionLot
                                                       and a.Product       = b.Product
                                                       and a.Plant         = b.Plant

{
  key a.Product,
  key a.Plant,
  key a.MatlDocNo         as GRMatlDocNo,
  key a.MatlDocYr         as GRMatlDocYr,
  key a.MatlDocItm        as GRMatDocItm,

  key a.MatlDocDate,
  key a.GoodsMovementType as GrMovmntTyp,
  key a.InspectionLot     as GRInspLotNo,
  key a.MaterialBaseUnit,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  key a.GRQty,

  key b.InspMatlDocNo     as QltyMatlDocNo,
  key b.InspMatlDocYr     as QltyMatlDocYr,
      b.InsMatlDocItm     as QltyMatlDocItm,
      b.InspMatlDocDate   as QltyMatDocDate,
      b.GoodsMovementType as QltyMovmntTyp,
      b.InspectionLot     as QltyInspLotNo,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      b.InspQty           as QltyQty
}
