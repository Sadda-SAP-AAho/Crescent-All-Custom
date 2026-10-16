@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GR Quantity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GRQTY
  as select distinct from ZI_GR_MAT_DOC_DETAILS as a
    inner join            ZCDS_CONTRACTOR_101   as b on  a.MatlDocNo = b.MaterialDocument
                                                     and a.Plant     = b.Plant
                                                     and a.Product   = b.Matnr

{
  key a.Product,
  key a.Plant,
  key b.Cont,
  key a.MatlDocDate,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum ( a.GRQty ) as GRQty
}

group by
  a.Product,
  a.Plant,
  b.Cont,
  a.MatlDocDate,
  a.MaterialBaseUnit
