@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I_salesdocumentitem'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_SALESORDER as select from I_SalesDocumentItem
{
    key SalesDocument,
    key SalesDocumentItem,
    UnderlyingPurchaseOrderItem
}
