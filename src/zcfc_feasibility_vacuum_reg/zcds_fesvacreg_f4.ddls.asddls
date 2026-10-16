@AbapCatalog.sqlViewName: 'Z_FESVACREG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FEASVACUUM-F4'
@Metadata.ignorePropagatedAnnotations: true

define view ZCDS_FESVACREG_F4
  as select distinct from ZCDS_FESVACREG_1
{

  key rfqno,
      rfqdate,
      matcd,
      line,
      fxdcst_cal,
      boxsize1,
      boxsize2,
      annualqty,
      mouldspd,
      reqweight,
      noofcav,
      yield,
      addacccost,
      drillperfacing,
      srfcarea,
      corecstpercav

}

where
  Rfq = 'X'
