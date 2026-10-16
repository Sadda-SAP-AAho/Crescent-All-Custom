@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Planning Material Master Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z_I_PLN_MAT_MSTR_HD
  as select from zpln_mat_mstr_hd as _hdr
  composition [1..*] of Z_I_PLN_MAT_MSTR_ITM as _item 
{

  key _hdr.requestuuid           as Requestuuid,
      _hdr.material_code         as Material_code,
      _hdr.material_desc         as Material_desc,
      _hdr.mother_item           as Mother_item,
      _hdr.child_item            as Child_item,
      _hdr.mother_child_catagory as Mother_child_catagory,
@Semantics.systemDateTime.createdAt: true      
      _hdr.created_at            as Created_at,
@Semantics.user.createdBy: true      
      _hdr.created_by            as Created_by,
@Semantics.systemDateTime.lastChangedAt: true    
      _hdr.last_changed_at       as Last_changed_at,
@Semantics.systemDateTime.localInstanceLastChangedAt: true      
_hdr.last_local_changed_at       as Last_local_changed_at, 
@Semantics.user.lastChangedBy: true      
      _hdr.last_changed_by       as Last_changed_by,
      _item
}
