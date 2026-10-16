@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pack List Final'
define view entity ZCDS_PACKLIST
  as select distinct from ZCDS_PLVALUES      as a
    left outer join       ZCDS_PACKLIST_DATA as b on a.packinglist = b.Packinglist
{
  key a.ReferenceSDDocument,
  key a.ReferenceSDDocumentItem,
      a.packinglist,
      a.Meins,
      a.qtysum,
      b.Createdon
}
