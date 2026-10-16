@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View for Capcity Type Master'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_CAPTYPMSTR_N
  provider contract transactional_query
  as projection on ZI_CAPTYPMSTR
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Code'
  key capcode,
      @EndUserText.label: 'Name'
  key capname,
      @EndUserText.label: 'Capacity/Line/Day'
      capperday,
      @EndUserText.label: 'No. of Line'
      noofline,
      @EndUserText.label: 'No. of Box'
      noofbox,
      @EndUserText.label: 'No. of Pattern'
      noofpatt,
      @EndUserText.label: 'Capacity Category'
      capcatg,
      @EndUserText.label: 'Rate for FC2'
      ratefc2

}
