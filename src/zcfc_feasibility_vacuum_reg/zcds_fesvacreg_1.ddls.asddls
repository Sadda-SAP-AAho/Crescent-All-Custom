@AbapCatalog.sqlViewName: 'Z_FESVACREG1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Feasibilty F4'
@Metadata.ignorePropagatedAnnotations: true

define view ZCDS_FESVACREG_1
  as select distinct from ZI_FESVACREG    as a
    left outer join       zdt_estvacreg_n as b on a.Rfqno = b.rfqno

    left outer join       zdt_fxdcstcal   as c on a.Line = c.mould
{
  key a.Rfqno                                                                 as rfqno,
      cast( case when b.rfqno is null then 'X' else 'Y' end as abap.char(1) ) as Rfq,
      a.Rfqdate                                                               as rfqdate,
      a.Matcd                                                                 as matcd,
      a.Line                                                                  as line,
      c.fxdcstrate                                                            as fxdcst_cal,
      a.Boxsize1                                                              as boxsize1,
      a.Boxsize2                                                              as boxsize2,
      a.Annualqty                                                             as annualqty,
      a.Mouldspd                                                              as mouldspd,
      a.Pd3d                                                                  as reqweight,
      a.Noofcav                                                               as noofcav,
      cast(abs( division( a.Yldprcnt,100, 3 ) ) as abap.dec(12,3) )           as yield,
      a.Addcst                                                                as addacccost,
      a.Drlfacing                                                             as drillperfacing,
      a.Srfcarea                                                              as srfcarea,
      a.Corecstpercav                                                         as corecstpercav

}
where
  a.Pduser is not initial
