@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Planning Material Master ITEM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_PLN_MAT_MSTR_ITM
  as select from zpln_mat_mst_itm as _item
  association to parent Z_I_PLN_MAT_MSTR_HD as _hdr on $projection.Requestuuid = _hdr.Requestuuid
{
    key _item.requestuuid  as Requestuuid,
    key _item.line_no      as Line_no,
key     _item.plant            as Plant,
    // Bring Material from header into line item
    _hdr.Material_code     as Material_code,


 
 


    _item.resource_no1     as Resource_no1,
    _item.resource_no1_desc as Resource_no1_desc,
    _item.cycle_time_r1    as Cycle_time_r1,
    _item.lead_time_r1     as Lead_time_r1,
    _item.batch_qty_r1     as Batch_qty_r1,

    _item.resource_no2     as Resource_no2,
    _item.resource_no2_desc as Resource_no2_desc,
    _item.cycle_time_r2    as Cycle_time_r2,
    _item.lead_time_r2     as Lead_time_r2,
    _item.batch_qty_r2     as Batch_qty_r2,

    _item.resource_no3     as Resource_no3,
    _item.resource_no3_desc as Resource_no3_desc,
    _item.cycle_time_r3    as Cycle_time_r3,
    _item.lead_time_r3     as Lead_time_r3,
    _item.batch_qty_r3     as Batch_qty_r3,

    _item.alternate_resource_no1 as Alternate_resource_no1,
    _item.alternate_resource_no1_desc as Alternate_resource_no1_desc,
    _item.cycle_time_ar1   as Cycle_time_ar1,
    _item.lead_time_ar1    as Lead_time_ar1,
    _item.batch_qty_ar1    as batch_qty_ar1,

    _hdr.Last_local_changed_at as Last_local_changed_at,
    _hdr
}
