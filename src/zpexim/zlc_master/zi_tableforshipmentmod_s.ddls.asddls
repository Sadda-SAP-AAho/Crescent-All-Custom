@EndUserText.label: 'Table for Shipment Mode Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_TableForShipmentMod_S
  as select from I_Language
    left outer join ZDT_SHIP_MODE on 0 = 0
  composition [0..*] of ZI_TableForShipmentMod as _TableForShipmentMod
{
  key 1 as SingletonID,
  _TableForShipmentMod,
  max( ZDT_SHIP_MODE.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
