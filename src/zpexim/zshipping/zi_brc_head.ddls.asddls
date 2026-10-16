@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view : BRC uploader header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_BRC_HEAD
  as select from zdt_brc_header
  composition [0..*] of ZI_BRC as _item
{

  key id                                                            as Id,
      internalno                                                    as Internalno,
      cast( case when status = '1' then 'Transaction saved'
                  when status = '2' then 'Validated'
                  when status = '3' then 'Processed'
                  else 'Instance Created' end as abap.char( 20 ) ) as Filestatus,
      cast( case when status = '1' then '1'
                   when status = '2' then '2'
                   when status = '3' then '3'
                   else '0' end as abap.char( 1 ) )                 as Criticalitystatus,
      //    hideexcel as Hideexcel,
      status                                                        as Status,
      @Semantics.largeObject: { mimeType: 'mimetype', fileName: 'filename', contentDispositionPreference: #INLINE }
      attachment                                                    as Attachment,
      @Semantics.mimeType: true
      mimetype                                                      as Mimetype,
      filename                                                      as Filename,
      comments                                                      as Comments,
      post                                                          as Post,
      @Semantics.user.createdBy: true
      localcreatedby                                                as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      localcreatedat                                                as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      locallastchangedby                                            as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat                                            as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat                                                 as LastChangedAt,
      valid                                                         as Valid,
      upd                                                           as Upd,
      _item
}
