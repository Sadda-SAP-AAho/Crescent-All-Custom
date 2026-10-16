@EndUserText.label: 'IP Purchase Group'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_IpPurchaseGroup
  as select from ZDT_IP_PURGR_TMG
  association to parent ZI_IpPurchaseGroup_S as _IpPurchaseGroupAll on $projection.SingletonID = _IpPurchaseGroupAll.SingletonID
{
  key PURCHASERMAIL as Purchasermail,
  PURCHASEGROUP as Purchasegroup,
  @Consumption.hidden: true
  1 as SingletonID,
  _IpPurchaseGroupAll
  
}
