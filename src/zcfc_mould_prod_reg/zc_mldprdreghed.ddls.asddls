@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View of Mld Prod Reg Head'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_MLDPRDREGHED
  provider contract transactional_query
  as projection on ZI_MLDPRDREGHED
{
      @EndUserText.label: 'ID'
  key ID,
      @EndUserText.label: 'Production Date '
      prddate,
      @EndUserText.label: 'Plant Code'
      plntcd,
      @EndUserText.label: 'Plant Name'
      plntnm,
      @EndUserText.label: 'Cost Centre'
      cstcntr,
      @EndUserText.label: 'Cost Centre Name'
      cstcntrnm,
      @EndUserText.label: 'Profit Centre'
      prftcntr,
      @EndUserText.label: 'Profit Centre Name'
      prftcntrnm,
      /* Associations */
      _Item : redirected to composition child ZC_MLDPRDREGITM

}
