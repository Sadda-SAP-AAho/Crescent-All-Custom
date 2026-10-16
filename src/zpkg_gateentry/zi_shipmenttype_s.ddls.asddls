@EndUserText.label: 'SHIPMENT TYPE Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZI_ShipmentType_S
  as select from I_Language
    left outer join ZDT_SHIPMENTTYPE on 0 = 0
  composition [0..*] of ZI_ShipmentType as _ShipmentType
{
  key 1 as SingletonID,
  _ShipmentType,
  max( ZDT_SHIPMENTTYPE.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
