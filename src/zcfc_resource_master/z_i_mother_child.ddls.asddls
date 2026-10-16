@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Mother Child'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity Z_I_Mother_Child as select from zmthr_chld_ctgry
{
    key requestuuid as Requestuuid,
  mother_child_catagory as Mother_child_catagory,
@Semantics.systemDateTime.createdAt: true
  created_at     as Created_at,
 @Semantics.user.createdBy: true
  created_by    as Created_by,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at    as Last_changed_at,
  @Semantics.user.localInstanceLastChangedBy: true
  last_changed_by    as Last_changed_by
}
