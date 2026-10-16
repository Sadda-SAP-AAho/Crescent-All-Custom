@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Quality Quantity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_INSPQUALITYQTY
  as select distinct from ZI_GR_INSP_MATL_DOC as a
    inner join            ZI_CONTRACTOR       as b on  a.QltyMatlDocNo = b.MaterialDocumentNo
                                                   and a.Plant         = b.Plant
                                                   and a.Product       = b.Matnr

{
  key a.Product,
  key a.Plant,
  key b.Cont,
  key a.QltyMatDocDate,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum ( a.QltyQty ) as QltyQty
}

where
       a.QltyInspLotNo is not initial

group by
  a.Product,
  a.Plant,
  b.Cont,
  a.QltyMatDocDate,
  a.MaterialBaseUnit
