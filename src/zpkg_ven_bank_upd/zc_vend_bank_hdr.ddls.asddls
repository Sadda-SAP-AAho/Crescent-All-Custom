@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cons View for Vendor Bank Upload'
@Metadata.allowExtensions: true
define root view entity ZC_VEND_BANK_HDR 
provider contract transactional_query
as projection on ZI_VEND_BANK_HDR 
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
    Upd,
    _item : redirected to composition child ZC_VEND_BANK_ITM
    
}
