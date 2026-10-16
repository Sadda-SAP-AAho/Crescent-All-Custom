@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for GSTR 2B Register Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #TRANSACTIONAL
}
define root view entity ZI_GSTR2BREG_H
  as select from zdt_gstr2breg_h
  composition [0..*] of ZI_GSTR2BREG_I as _Item
{
  key id,
      internalno,
      cast(
        case
          when filename is not initial then ' '
          else 'X'
        end
        as boolean preserving type
      )                                                                as HideExcel,
      @Semantics.largeObject: {
        mimeType: 'mimetype',
        fileName: 'filename',
        contentDispositionPreference: #INLINE
      }
      attachment,
      @Semantics.mimeType: true
      mimetype,
      filename,
      comments,
      fisyear,
      docnum,
      keyid,
      location,
      fyear,
      fmonthcd,
      fmonth,
      canceled,
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
      _Item
}
