@AbapCatalog.sqlViewName: 'ZVIEW2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Per Day View'
@Metadata.ignorePropagatedAnnotations: true

define view ZCDS_PERDAYVIEW

  as select from ZCDS_PERDAYVIEW_1

{
  key shpflrdt,
  key opr,
  key plant,
  key dept,
  key cont,
  key matnr,

      MaterialBaseUnit,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( ReqQty ) as ReqQty
}

where
  matnr <> 'X'

group by
  shpflrdt,
  opr,
  plant,
  dept,
  cont,
  matnr,
  MaterialBaseUnit
