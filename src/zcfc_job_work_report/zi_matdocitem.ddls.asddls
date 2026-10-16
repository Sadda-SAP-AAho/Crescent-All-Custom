@AbapCatalog.sqlViewName: 'ZMATDOCITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tax Value-Calculation'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_MATDOCITEM
  as select distinct from I_MaterialDocumentItem_2 as a
{
  key a.MaterialDocument,
  key a.MaterialDocumentYear,
  key a.MaterialDocumentItem,
  key a.PurchaseOrder,
  key a.PurchaseOrderItem,

  key lpad( a.MaterialDocumentItem, 6, '0' ) as RefDocumentItem

}
