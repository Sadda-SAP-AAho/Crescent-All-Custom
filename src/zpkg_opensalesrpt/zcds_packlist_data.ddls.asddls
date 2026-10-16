@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List Data'
define view entity ZCDS_PACKLIST_DATA
  as select distinct from ZI_PACKLIST_ITM as a
  inner join ZI_PACKLIST_HDR as b on a.Id = b.Id
{
//  key a.id,
  key a.Packinglist,
  b.Createdon
}
where b.Canind is initial
