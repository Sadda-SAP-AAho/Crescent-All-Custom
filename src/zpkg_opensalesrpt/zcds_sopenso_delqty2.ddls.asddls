@AbapCatalog.sqlViewName: 'ZV_DELQTY2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for delivery details'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_SOPENSO_DELQTY2
  as select from    I_SalesOrderItem    as c
    left outer join ZCDS_SOPENSO_DELQTY as a on  c.SalesOrder     = a.ReferenceSDDocument
                                             and c.SalesOrderItem = a.ReferenceSDDocumentItem
{
  c.SalesOrder     as ReferenceSDDocument,
  c.SalesOrderItem as ReferenceSDDocumentItem,
  c.OrderQuantityUnit,
  @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
  c.OrderQuantity,
  a.delivqty,
  a.DeliveryQuantityUnit
}
