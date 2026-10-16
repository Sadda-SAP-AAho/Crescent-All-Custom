@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_WORK_ITEMS
  as select from zwork_items
association to ZVH_CURRENCIES as _currency on $projection.Currency = _currency.Currency
  association to parent ZR_WORK_HEADER as _header
  on $projection.PlantCode  = _header.PlantCode
  and $projection.WorkCode = _header.WorkCode
{
  key plant_code as PlantCode,
  key work_code as WorkCode,
  key date_from as DateFrom,
  key date_to as DateTo,
  uom as Uom,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency as Currency,
  @Semantics.amount.currencyCode: 'Currency'
  rate as Rate,
  begin_date as BeginDate,
  end_date as EndDate,
  created_by as CreatedBy,
  created_at as CreatedAt,
  last_changed_by as LastChangedBy,
  last_changed_at as LastChangedAt,
  @Semantics.user.createdBy: true
  localcreatedby as Localcreatedby,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locallastchangedby as Locallastchangedby,
  @Semantics.user.createdBy: true
  localcreatedat as Localcreatedat,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locallastchangedat as Locallastchangedat,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchangeat as Lastchangeat,
  _header,
  _currency
  
}
