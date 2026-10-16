@AbapCatalog.sqlViewName: 'ZPWRHEADCOMPCAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Power Head Comp Cal'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PWRHEADCOMPCAL
  as select distinct from ZI_PWRRDNGHEAD as a
    inner join            ZI_PWRRDNGITEM as b on a.Id = b.Id
    left outer join       ZI_PWRHDMASTER as c on  b.Subhdcd = c.Subheadcd
                                              and b.Headcd  = c.Headcd
{
  key a.Id,
  key b.Item,
  key a.Docnum,
      a.Readdate,
      a.Readloccd,
      a.Readlocnm,
      a.Readdept,
      a.UnitRate,
      b.Subhdcd,
      b.Subhdnm,
      b.Headcd,
      b.Headnm,
      b.Metertyp,
      b.Meterrdng,

      c.Diprcnt,
      div ( ( cast ( b.Meterrdng as abap.dec( 16, 3 ) ) * cast ( c.Diprcnt as abap.dec( 16, 3 ) ) ) , 100 ) as DiUnits,

      c.Ciprcnt,
      div ( ( cast ( b.Meterrdng as abap.dec( 16, 3 ) ) * cast ( c.Ciprcnt as abap.dec( 16, 3 ) ) ) , 100 ) as CiUnits

}
