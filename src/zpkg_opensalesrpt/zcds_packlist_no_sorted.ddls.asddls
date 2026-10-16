@AbapCatalog.sqlViewName: 'ZV_SORT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PL'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_PACKLIST_NO_SORTED
  as select from ZTBL_FUNC_PACKLIST

{
  key ReferenceSDDocument,
  key ReferenceSDDocumentItem,
  max(packinglist) as packinglist
}
group by 
  ReferenceSDDocument,
  ReferenceSDDocumentItem
