@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO wise packing List Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_SOPCKLSTRPT
  as select from ZI_SOPCKLSTRPT
{
       @EndUserText.label: 'SO No'
       @Search.defaultSearchElement: true
  key  so_no,
       @UI.hidden: true
  key  so_item,
       @EndUserText.label: 'Outbound No'
  key  outbnd_no,
       @UI.hidden: true
  key  outbnd_Item,
       @EndUserText.label: 'SO Date'
       so_dt,
       @EndUserText.label: 'Customer Code'
       cust_code,
       @EndUserText.label: 'Material No'
       mat_code,
       @EndUserText.label: 'Description'
       mat_des,
       @UI.hidden: true
       OrderQuantityUnit,
       @EndUserText.label: 'Order qty'
       ord_qty,
       @EndUserText.label: 'Outbound Date'
       outbnd_dt,
       @UI.hidden: true
       DeliveryQuantityUnit,
       @EndUserText.label: 'Outbound Qty'
       outbnd_qty
}
