@EndUserText.label: 'Product Group Maintenance'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_ProductGroupMainten
  as select from ZDT_PRGROUP_TMG
  association to parent ZI_ProductGroupMainten_S as _ProductGroupMainAll on $projection.SingletonID = _ProductGroupMainAll.SingletonID
{
  key PRODUCTGROUP as Productgroup,
  @Consumption.hidden: true
  1 as SingletonID,
  _ProductGroupMainAll
  
}
