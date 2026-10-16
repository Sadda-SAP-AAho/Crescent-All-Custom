@AbapCatalog.sqlViewName: 'ZGROSSWT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Gross Weight'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_GROSSWT
  as select distinct from ZI_PACKLIST_ITM as a
    inner join            ZI_PACKLIST_HDR as b on  a.Packinglist =  b.Packinglist
                                               and b.Canind      <> 'X'
                                               and a.Id          =  b.Id
    inner join            ZI_MAXCRATEWT   as c on  b.Packinglist = c.Packinglist
                                               and a.Priority    = c.Priority
    inner join            ZI_NETWT        as d on  a.Packinglist = d.Packinglist
                                               and a.Matnr       = d.Matnr
                                               and a.Item        = d.Item

{
  key a.Packinglist,
  key a.Item,
      a.Matnr,
      a.Priority,
      cast( d.NetWt as abap.dec( 13, 3) )                                            as NetWt,

      cast( d.NetWt as abap.dec( 13, 3) ) + cast( c.MaxCrateWt as abap.dec( 13, 3) ) as GrossWt
}

where
  a.Priority <> '00000'
//  and a.Packinglist =  '2502110012'
