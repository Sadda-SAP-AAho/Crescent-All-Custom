@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM wise Material Planning and Resource Info'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_BOMMATRESINFO
  as select distinct from ZR_BOMCOST_RPT      as a
    left outer join       ZI_MATRESINFO       as b on  a.Component = b.Material_code
                                                   and a.Plant     = b.Plant
    left outer join       ZI_BOM_COMP_DETAILS as c on  a.Parent    = c.Material
                                                   and a.Plant     = c.plant
                                                   and a.Component = c.BillOfMaterialComponent



{
      // BOM COST REPORT-HEADER MATERIAL INFO //

  key a.Plant,
  key a.Hedmaterial,
  key a.HeaderGrpCode,
  key a.HeaderGrpName,
  key a.HeadQty,
  key a.Bomlevel,
  key a.Parent,
  key a.Component,
  key c.StorageLocation,
      @Semantics.quantity.unitOfMeasure: 'ParentGrossWtUnit'
      a.ParentGrosswt,
      a.ParentGrossWtUnit,

      a.ChildDesc,

      a.ChildGrpCode,
      a.ChildGrpName,
      a.Childqty,
      a.Bomitemqtyunit,
      @Semantics.quantity.unitOfMeasure: 'ChildWtUnit'
      a.ChildNetwt,
      a.ChildWtUnit,
      a.ChildPlant,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.ChildMatlStock,

      b.Resource_no1,
      b.Resource_no1_desc,
      b.Cycle_time_r1,
      b.Lead_time_r1,
      b.Batch_qty_r1,

      b.Resource_no2,
      b.Resource_no2_desc,
      b.Cycle_time_r2,
      b.Lead_time_r2,
      b.Batch_qty_r2,

      b.Resource_no3,
      b.Resource_no3_desc,
      b.Cycle_time_r3,
      b.Lead_time_r3,
      b.Batch_qty_r3

}

where
  (
       a.ChildGrpCode = 'Z023'
    or a.ChildGrpCode = 'Z024'
    or a.ChildGrpCode = 'Z025'
    or a.ChildGrpCode = 'Z026'
    or a.ChildGrpCode = 'Z027'
    or a.ChildGrpCode = 'Z028'
    or a.ChildGrpCode = 'Z045'
  )

  and  a.Costitemcat  = 'M'
