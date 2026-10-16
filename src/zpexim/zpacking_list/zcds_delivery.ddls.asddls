@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I_Deliverydocument'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_DELIVERY as select from I_DeliveryDocumentItem
{
    key DeliveryDocument,
    key DeliveryDocumentItem,
    ReferenceSDDocument,
    ReferenceSDDocumentItem
}
