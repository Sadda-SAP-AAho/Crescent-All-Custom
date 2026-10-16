@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Invoice Info File'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_INVINFO_FILE
  as select from zdt_invinfo_file
  composition [0..*] of ZI_INVITEM_FILE as _item
{
  key id,
      internalno,
      cast( case when status = '1' then 'Transaction saved'
                 when status = '2' then 'Validated'
                 when status = '3' then 'Processed' end as abap.char( 20 ) )                      as FileStatus,
      cast( case when status = '1' then '1'
                 when status = '2' then '2'
                 when status = '3' then '3' end as abap.char( 1 ) )                               as CriticalityStatus,
      cast( case when filename is not initial then ' ' else 'X' end as boolean preserving type  ) as HideExcel,
      status,
      @Semantics.largeObject: { mimeType: 'mimetype', fileName: 'filename', contentDispositionPreference: #INLINE }
      attachment,
      @Semantics.mimeType: true
      mimetype,
      filename,
      comments,
      post,
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
      'X'                                                                                         as Valid,
      'X'                                                                                         as Upd,
      _item
}
