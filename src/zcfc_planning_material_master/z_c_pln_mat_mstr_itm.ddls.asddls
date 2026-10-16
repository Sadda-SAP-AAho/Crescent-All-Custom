@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection Planning Mat Mast ITM'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity Z_C_PLN_MAT_MSTR_ITM
  as projection on Z_I_PLN_MAT_MSTR_ITM
{
    key Requestuuid,
    key Line_no,
key Plant,
    @UI.hidden: true
    Material_code,  





    Resource_no1,
    Resource_no1_desc,
    Cycle_time_r1,
    Lead_time_r1,
    Batch_qty_r1,
    Resource_no2,
    Resource_no2_desc,
    Cycle_time_r2,
    Lead_time_r2,
    Batch_qty_r2,
    Resource_no3,
    Resource_no3_desc,
    Cycle_time_r3,
    Lead_time_r3,
    Batch_qty_r3,
    Alternate_resource_no1,
    Alternate_resource_no1_desc,
    Cycle_time_ar1,
    Lead_time_ar1,
    batch_qty_ar1,
    Last_local_changed_at,

    _hdr : redirected to parent Z_C_PLN_MAT_MSTR_HD
}
