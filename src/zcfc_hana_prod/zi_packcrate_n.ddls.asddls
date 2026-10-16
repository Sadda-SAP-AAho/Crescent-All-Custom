@AbapCatalog.sqlViewName: 'ZPACKCRATEN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Defination of Pack Crate'
@Metadata.ignorePropagatedAnnotations: true

define view ZI_PACKCRATE_N
  as select distinct from ZI_PACKLIST_ITM as a
    inner join            ZI_PACKLIST_HDR as b on  a.Packinglist =  b.Packinglist
                                               and b.Canind      <> 'X'
                                               and a.Id          =  b.Id
    inner join            I_Product       as c on a.Matnr = c.Product
{
  key a.Packinglist,
  key a.Item,
      a.Matnr,
      a.Priority,
      cast( c.NetWeight as abap.dec(13,3) )  as MatNetWt,
      cast( a.Mateachpkg as abap.dec(13,3) ) as PackCrate

}
where
  a.Priority <> '00000'
