@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I_BILLINGDOCUMENTPARTNER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zI_BILLINGDOCUMENTPARTNER as select from I_BillingDocumentPartner
{
     key BillingDocument,


  key PartnerFunction,

   Customer,

   Supplier,

    Personnel,

     AddressID,
  AddressObjectType,
ContactPerson,

    AddressPersonID,
   ReferenceBusinessPartner,
    SDDocPartnerAddressRefType,
      
   VATRegistration,
    UnloadingPointName,
      
BPRefAddressIDForDocSpcfcAddr
}
