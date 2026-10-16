@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Estimated Vaccum Printout'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_ESTIMATED_VACCUM_PRINTOUT
  as select from ZI_ESTVACRPT
{

  key id,

      rfqno,

      rfqdate,

      matcd,

      rejection,

      tolerance,

      margin,

      amtmrgn,

      fxdcst_ue,

      line,

      annualqty,

      mouldspd,

      reqweight,

      nominal,

      noofcav,

      yield,

      addacccost,

      drillperfacing,

      srfcarea,

      chrgingcst,

      metalcstperton,

      elccst,

      mldcst,

      acccavity,

      packngcst,

      corecstcav,

      curr,

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

      exchngrt,

      totlcstprpccal,

      totlcstprkgcal,

      cstusdprmtcal,

      pckngcstcal,

      offprprccal,

      offprkgcal,

      usdprpccal,

      usdprmtcal,

      prcprlbcal,

      agreedincoterm,

      freightchrg,

      frghtkgFX,

      frghtpc,

      partpcs,

      inrkg,

      FXkg,

      freightrmrks
}
