@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'GSTR 2B Register-Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_GSTR2BREG_HD
  provider contract transactional_query
  as projection on ZI_GSTR2BREG_HD
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Fisyear'
      Fisyear,
      @EndUserText.label: 'Document No.'
      Docnum,
      @EndUserText.label: 'Keyid'
      Keyid,
      @EndUserText.label: 'Created on'
      Creon,
      @EndUserText.label: 'Created by'
      Creby,
      @EndUserText.label: 'Location'
      Location,
      @EndUserText.label: 'Financial Year'
      Fyear,
      @EndUserText.label: 'Month Code'
      Fmonthcd,
      @EndUserText.label: 'Month'
      Fmonth,
      /* Associations */
      _Item : redirected to composition child ZC_GSTR2BREG_IT
}
