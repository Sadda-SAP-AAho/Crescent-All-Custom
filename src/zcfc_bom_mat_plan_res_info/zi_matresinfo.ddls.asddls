@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Resource Info'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MATRESINFO
  as select distinct from Z_I_PLN_MAT_MSTR_HD  as b
    inner join            Z_I_PLN_MAT_MSTR_ITM as c on b.Requestuuid = c.Requestuuid
{

  key b.Material_code,
  key c.Plant,

      c.Resource_no1,
      c.Resource_no1_desc,
      c.Cycle_time_r1,
      c.Lead_time_r1,
      c.Batch_qty_r1,

      c.Resource_no2,
      c.Resource_no2_desc,
      c.Cycle_time_r2,
      c.Lead_time_r2,
      c.Batch_qty_r2,

      c.Resource_no3,
      c.Resource_no3_desc,
      c.Cycle_time_r3,
      c.Lead_time_r3,
      c.Batch_qty_r3
}
