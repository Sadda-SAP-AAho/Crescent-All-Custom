@EndUserText.label: 'Consumption View of Advance Upload'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity zc_advanceupload
  provider contract transactional_query
  as projection on zi_advanceupload
{
  key Id,
      @EndUserText.label: 'Attachment'
      Attachment,
      CriticalityStatus,
      HideExcel,
      FileStatus,
      @EndUserText.label: 'Mime Type'
      Mimetype,
      @EndUserText.label: 'File Name'
      Filename,
      @EndUserText.label: 'Post'
      Post,
      @EndUserText.label: 'Status'
      Status,
      @EndUserText.label: 'Last Created By'
      LocalCreatedBy,
      @EndUserText.label: 'Last Created At'
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      /* Associations */
      _item : redirected to composition child zc_advanceuploaditm
}
