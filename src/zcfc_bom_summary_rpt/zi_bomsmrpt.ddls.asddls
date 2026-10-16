@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Summary Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_BOMSMRPT
  as select distinct from ZI_BOMSMRPT_BASIC
{
  key Plant,
  key custcode,
  key matcode,
      matname,
      moc,
      salesperson,
      WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      NetWeight,
      mcloss,
      qtybox,
      typmold,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      bunchwt,
      sqmtr,
      yield,
      lmmatl,
      metalprc,
      ditrtcost,
      eleccost,
      ttlcost,
      packmtlcost,
      accscost,
      genstrcost,
      pntmtlcostkg,
      pntmtlcostsqm,
      convcost,
      labrcost,
      labrcostsp,
      rateprsqm,
      labrcostgr,
      labrcostoth,
      labrcoststr,
      meltlosscst,
      machncst,
      ttllabcost,
      ttlcstpcs,
      ttlcstkg,
      ttlselexp

}
