@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Last PO Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_SUPPLIER_LAST_PO
  as select distinct from I_PurchaseOrderAPI01     as a
    inner join            I_PurchaseOrderItemAPI01 as b on a.PurchaseOrder = b.PurchaseOrder
    left outer join       I_BusinessUserBasic      as c on a.CreatedByUser = c.UserID
{
  key a.Supplier,
  key a.PurchaseOrder,
      a.PurchaseOrderDate,
      c.PersonFullName as CreatedByUser

}

where
  b.PurchasingDocumentDeletionCode is initial
