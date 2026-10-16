@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR VACUUM KUL'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #XXL,
    dataClass: #TRANSACTIONAL
}
define root view entity ZC_DPR_VACK_HEAD
  as projection on ZI_DPR_VACK_HEAD
{
      @EndUserText.label: 'Plant'
      @Search.defaultSearchElement: true
  key plant,
      @EndUserText.label: 'Dept'
      @Search.defaultSearchElement: true
  key Kostl,
      @EndUserText.label: 'Report Date'
      indate,
      @EndUserText.label: 'Update'
      upd,
      @UI.hidden: true
      lastupdby,
      @UI.hidden: true
      lastupdon,
      @UI.hidden: true
      lastupdat,
      /* Associations */
      _item : redirected to composition child ZC_DPR_VACK_ITM

}
