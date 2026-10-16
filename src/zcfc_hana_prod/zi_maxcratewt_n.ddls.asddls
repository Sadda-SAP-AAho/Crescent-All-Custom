@AbapCatalog.sqlViewName: 'ZMAXCRATEWTN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Defination of Max Crate Weight'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_MAXCRATEWT_N
  as select distinct from ZI_PACKLIST_ITM as a
    inner join            ZI_PACKLIST_HDR as b on  a.Packinglist =  b.Packinglist
                                               and b.Canind      <> 'X'
                                               and a.Id          =  b.Id
{
  key a.Packinglist,
      a.Priority,
      max(a.Packmatnwt) as MaxCrateWt
}

where
  a.Priority <> '00000'
//  and a.Packinglist =  '2502110012'

group by
  a.Packinglist,
  a.Priority
