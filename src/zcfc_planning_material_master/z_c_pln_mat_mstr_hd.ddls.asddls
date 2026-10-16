 @AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection Planning Mat Mast Hdr'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root  view entity Z_C_PLN_MAT_MSTR_HD  provider contract transactional_query   as projection on Z_I_PLN_MAT_MSTR_HD
{
    key Requestuuid,
    Material_code,
    Material_desc,
    Mother_item,
    Child_item,
    Mother_child_catagory,
    Created_at,
    Created_by,
    Last_changed_at,
    Last_local_changed_at,
    Last_changed_by,
    /* Associations */
    _item : redirected to composition child Z_C_PLN_MAT_MSTR_ITM
}
