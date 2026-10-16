@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for posting date'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_POSTINGDATE
  as select distinct from ZCDS_POSTINGDATE_1
{
  key shpflrno,
  key PostingDate

}

where
    PostingDate <> '00000000'

group by
  shpflrno,
  PostingDate
