@AbapCatalog.sqlViewName: 'ZNETWT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Net Weight'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_NETWT
  as select distinct from ZI_PACKLIST_ITM as a
    inner join            ZI_PACKLIST_HDR as b on  a.Packinglist =  b.Packinglist
                                               and b.Canind      <> 'X'
                                               and a.Id          =  b.Id
    inner join            ZI_PACKCRATE c       on  a.Packinglist = c.Packinglist
                                               and a.Matnr       = c.Matnr
                                               and a.Priority    = c.Priority
                                               and a.Item        = c.Item
{
  key a.Packinglist,
  key a.Item,
      a.Matnr,
      cast( c.PackCrate as abap.dec(13,3) ) * cast( c.MatNetWt as abap.dec(13,3) ) as NetWt

}
where
  a.Priority <> '00000'
//  and a.Packinglist =  '2502110012'
