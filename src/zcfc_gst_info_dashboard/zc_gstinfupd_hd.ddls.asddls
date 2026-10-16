@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST Information Dashboard Uploader-Header'
@Metadata.allowExtensions: true

define root view entity ZC_GSTINFUPD_HD
  provider contract transactional_query
  as projection on ZI_GSTINFUPD_HD
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
      Valid,
      Upd,
      /* Associations */
      _item : redirected to composition child ZC_GSTINFUPD_IT
}
