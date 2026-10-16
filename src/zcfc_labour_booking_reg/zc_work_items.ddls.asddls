@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZC_WORK_ITEMS
  as projection on ZR_WORK_ITEMS
{
  key PlantCode,
  key WorkCode,
  key DateFrom,
  key DateTo,
  Uom,
  @Semantics.currencyCode: true
  Currency,
  Rate,
  BeginDate,
  EndDate,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  Localcreatedby,
  Locallastchangedby,
  Localcreatedat,
  Locallastchangedat,
  Lastchangeat,
  _currency,
  _header : redirected to parent ZC_WORK_HEADER
}
