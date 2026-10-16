@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Transporter Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_transporterdetails
  as select distinct from ZI_DELDASH_HDR
{
  key Delivery,
      forwarder,
      forwardernam,
      Contno
}
where
  Canind <> 'X'
