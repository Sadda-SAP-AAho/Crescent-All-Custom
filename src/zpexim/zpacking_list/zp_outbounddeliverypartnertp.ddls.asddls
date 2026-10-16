@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I_OutboundDeliveryPartnerTP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZP_OutboundDeliveryPartnerTP provider contract transactional_query as projection on  I_OutboundDeliveryPartnerTP
{

  key OutboundDelivery,
  key PartnerFunction,

      Customer,
      Supplier,
      Personnel,
      AddressID,
      AddressPersonID,
      ContactPerson
}
