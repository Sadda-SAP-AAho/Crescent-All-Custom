@AbapCatalog.sqlViewName: 'ZFEASVACUUMF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FEASVACUUM-F4'
@Metadata.ignorePropagatedAnnotations: true

define view ZCDS_FEASVACUUM_F4
  as select from ZI_FEASVACUUM_F4
{
  key matcd,
  key rfqdate,
      typofmld,
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
      tonnagecal,
      wgtprbxcal,
      mltngcstmtcal,
      totlcstmtcal,
      totlcsttolcal,
      mtlcstprpccal,
      labmldperbxcal,
      mntprpccal,
      fetcstprpccal,
      cstmldprmtcal,
      pntprmrcstcal,
      mnfcostcal,
      cstvaprpccal,
      fcprkgcal,
      sellexpcal,
      seperkg,
      totlcstprpccal,
      totlcstprkgcal,
      cstusdprmtcal,
      pckngcstcal,
      offprprccal,
      offprkgcal,
      usdprpccal,
      usdprmtcal,
      prcprlbcal
}
