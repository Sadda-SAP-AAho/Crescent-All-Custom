@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EXIM Club Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_EXIMCLUBHDR

  as select from zexim_club_hdr

  composition [0..*] of ZI_EXIMCLUBITM as _item

{

  key id,
      clubnointernal,
      clubnoexternal,
      clubcomment,
      documenttype,
      documenttypedesc,
      cdate,
      ctime,
      cuser,
      @Semantics.amount.currencyCode: 'fobcurrency'
      fobamount,
      fobcurrency,
      deleted,
      released,
      @Semantics.user.createdBy: true
      local_created_by,
      @Semantics.systemDateTime.createdAt: true
      local_created_at,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at,

      _item

}
