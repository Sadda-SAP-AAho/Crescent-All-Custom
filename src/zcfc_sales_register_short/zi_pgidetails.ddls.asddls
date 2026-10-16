@AbapCatalog.sqlViewName: 'ZPGIDETAILS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for PGI Details'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PGIDETAILS
  as select distinct from I_MaterialDocumentHeader_2 as a
    left outer join       I_MaterialDocumentItem_2   as b on  a.MaterialDocument         = b.MaterialDocument
                                                          and b.GoodsMovementType        = '601'
                                                          and b.GoodsMovementIsCancelled is initial
    left outer join       I_BillingDocumentItem      as c on  a.DeliveryDocument     = c.ReferenceSDDocument
                                                          and b.DeliveryDocumentItem = c.ReferenceSDDocumentItem
{
  key    a.MaterialDocumentYear,
  key    a.MaterialDocument as PGI_No,
  key    a.PostingDate      as PGI_Date,
  key    a.DeliveryDocument,
  key    b.DeliveryDocumentItem,
  key    c.BillingDocumentItem,
         b.Material
}
