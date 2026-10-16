@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Work Code'
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.dataCategory: #VALUE_HELP
define view entity ZVH_WORK_CODE
  as select from zwork_items as items
    inner join zwork_header as header
      on items.work_code = header.work_code
{
    key items.plant_code as PlantCode,
    key items.work_code as WorkCode,
    key items.date_from as DateFrom,
    key items.date_to as DateTo,
        @Semantics.text: true
        @UI.hidden: true
        header.work_name as work_description,
        @UI.hidden: true
        items.uom as UOM,
        @UI.hidden: true
        items.currency as Currency,
        @UI.hidden: true
        @Semantics.amount.currencyCode: 'Currency'
        items.rate as Rate
}
