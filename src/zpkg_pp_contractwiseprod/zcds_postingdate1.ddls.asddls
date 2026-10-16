@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for posting date 2'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_POSTINGDATE1
  as select from ZCDS_POSTINGDATE as b
    inner join   zdt_confpost_hdr as a on b.shpflrno = a.shpflrno
    left outer join ZI_CONTRACTOR_F4 as c on c.Zcon = a.cont
{
//  key b.PostingDate as Shpflrdt,
  key a.opr         as Opr,
  key a.plant       as Plant,
  key a.dept        as Dept,
  key a.cont        as Cont,
      a.deptname    as Deptname,
      a.oprname     as Oprname,
      c.Zcod        as Contname
}
group by
//  b.PostingDate,
  a.opr,
  a.plant,
  a.dept,
  a.cont,
  a.deptname,
  a.oprname,
  c.Zcod
