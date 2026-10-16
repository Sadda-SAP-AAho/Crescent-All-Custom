@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Advance Upload'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_advanceupload
  as select from zadvpay_hdr
  composition [0..*] of zi_advanceuploaditm as _item
{
  key id                                                                                          as Id,
      //      companycode           as Companycode,
      //      documentdate          as Documentdate,
      //      postingdate           as Postingdate,
      //      text                  as Text,
      //      reference             as Reference,
      //      currency              as Currency,
      //      exchangerate          as Exchangerate,
      @Semantics.largeObject: { mimeType: 'mimetype', fileName: 'filename', contentDispositionPreference: #INLINE }
      attachment                                                                                  as Attachment,
      @Semantics.mimeType: true
      mimetype                                                                                    as Mimetype,
      filename                                                                                    as Filename,
      post                                                                                        as Post,
      cast( case when post = 'X' then 'Transaction posted'
      when ( post = ' ' and filename is not initial ) then 'Transaction saved'
      else 'Created' end as abap.char( 20 ) )                                                     as FileStatus,
      cast( case when post = 'X' then '3'
      when ( post = ' ' and filename is not initial ) then '2'
      else '1' end as abap.char( 1 ) )                                                            as CriticalityStatus,
      cast( case when filename is not initial then ' ' else 'X' end as boolean preserving type  ) as HideExcel,
      status                                                                                      as Status,
      @Semantics.user.createdBy: true
      local_created_by                                                                            as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at                                                                            as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by                                                                       as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                                                                       as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                                                                             as LastChangedAt,
      _item
}
