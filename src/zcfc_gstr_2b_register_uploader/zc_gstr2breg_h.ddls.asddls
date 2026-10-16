@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR 2B Register Header'
@Metadata.allowExtensions: true

define root view entity ZC_GSTR2BREG_H
  provider contract transactional_query
  as projection on ZI_GSTR2BREG_H
{
  key id,
      internalno,
      HideExcel,
      attachment,
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
      local_created_by,
      local_created_at,
      local_last_changed_by,
      local_last_changed_at,
      last_changed_at,

      /* Associations */
      _Item : redirected to composition child ZC_GSTR2BREG_I
}
