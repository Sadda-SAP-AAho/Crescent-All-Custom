@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Material Info File'
@Metadata.allowExtensions: true
define root view entity ZC_OPR_UPD_HDR 
provider contract transactional_query
as projection on ZI_OPR_UPD_HDR
{
    key id,
    internalno,
    FileStatus,
    CriticalityStatus,
    HideExcel,
    status,
    attachment,
    mimetype,
    filename,
    comments,
    post,
    local_created_by,
    local_created_at,
    local_last_changed_by,
    local_last_changed_at,
    last_changed_at,
    Valid,
    Upd,
    /* Associations */
    _item : redirected to composition child ZC_OPR_UPD_ITM
}
