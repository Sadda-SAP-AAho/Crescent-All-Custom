@AbapCatalog.sqlViewName: 'ZV_DELQTY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for delivrey related details'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_SOPENSO_DELQTY1
  as select from ZCDS_SOPENSO_DELQTY2
{
  ReferenceSDDocument,
  ReferenceSDDocumentItem,
  OrderQuantityUnit,
  OrderQuantity,
  @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
  cast( ( coalesce( OrderQuantity, 0 ) - coalesce( delivqty, 0 ) ) as abap.quan( 13, 3 ) ) as balanceqty,
  delivqty,
  DeliveryQuantityUnit
}
