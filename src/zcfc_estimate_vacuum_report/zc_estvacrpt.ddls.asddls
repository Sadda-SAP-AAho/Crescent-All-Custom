@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Estimate Vacuum Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_ESTVACRPT
  provider contract transactional_query
  as projection on ZI_ESTVACRPT
{


      @UI.hidden: true
  key id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Rfq No'
      rfqno,
      @EndUserText.label: 'Rfq Date'
      rfqdate,
      @EndUserText.label: 'Drawing No.'
      matcd,
      @EndUserText.label: 'Rejection '
      rejection,
      @EndUserText.label: 'Tolerance'
      tolerance,
      @EndUserText.label: 'Margin %'
      margin,
      @EndUserText.label: 'Margin INR'
      amtmrgn,
      @EndUserText.label: 'Fixed Cost'
      fxdcst_ue,
      @EndUserText.label: 'Line'
      line,
      @EndUserText.label: 'Annual Qty'
      annualqty,
      @EndUserText.label: 'Mould Speed'
      mouldspd,
      @EndUserText.label: 'Required Wt(Kg)'
      reqweight,
      @EndUserText.label: 'Nominal'
      nominal,
      @EndUserText.label: 'No of Cavities'
      noofcav,
      @EndUserText.label: 'Yield'
      yield,
      @EndUserText.label: 'Additional Accessories Cost '
      addacccost,
      @EndUserText.label: 'Machining Cost'
      drillperfacing,
      @EndUserText.label: 'Surface Area'
      srfcarea,
      @EndUserText.label: 'Charging Cost/MT'
      chrgingcst,
      @EndUserText.label: 'Metal Cost/Ton'
      metalcstperton,
      @EndUserText.label: 'Electricity Cost/Box'
      elccst,
      @EndUserText.label: 'Molding Cost/Box'
      mldcst,
      @EndUserText.label: 'Accessories Cavity'
      acccavity,
      @EndUserText.label: 'Packaging Cost'
      packngcst,
      @EndUserText.label: 'Core Cost Cavity'
      corecstcav,
      @EndUserText.label: 'Currency'
      curr,
      @EndUserText.label: 'Tonnage'
      tonnagecal,
      @EndUserText.label: 'Weight/Box(Kg)'
      wgtprbxcal,
      @EndUserText.label: 'Melting Cost/MT'
      mltngcstmtcal,
      @EndUserText.label: 'Total Cost/MT'
      totlcstmtcal,
      @EndUserText.label: 'Total Cost/MT with Tolerance'
      totlcsttolcal,
      @EndUserText.label: 'Metal Cost/Pcs'
      mtlcstprpccal,
      @EndUserText.label: 'Labour for Moulding/Box'
      labmldperbxcal,
      @EndUserText.label: 'Maintenance/Pcs'
      mntprpccal,
      @EndUserText.label: 'Fettling Cost/Pcs'
      fetcstprpccal,
      @EndUserText.label: 'Cost of Molding/MT'
      cstmldprmtcal,
      @EndUserText.label: 'Paint(Labour+Material)-Primer Cost(Cal)'
      pntprmrcstcal,
      @EndUserText.label: 'Manufacturing Cost-w/o VA/KG'
      mnfcostcal,
      @EndUserText.label: 'Cost of VA/PC'
      cstvaprpccal,
      @EndUserText.label: 'FC/Kg'
      fcprkgcal,
      @EndUserText.label: 'Selling Expense'
      sellexpcal,
      @EndUserText.label: 'SE/KG'
      seperkg,
      @EndUserText.label: 'Exchange Rate'
      exchngrt,
      @EndUserText.label: 'Total Cost/Pcs'
      totlcstprpccal,
      @EndUserText.label: 'Total Cost/Kg'
      totlcstprkgcal,
      @EndUserText.label: 'Cost-FX/MT'
      cstusdprmtcal,
      @EndUserText.label: 'Packaging Cost/Pcs'
      pckngcstcal,
      @EndUserText.label: 'Offers/Pcs'
      offprprccal,
      @EndUserText.label: 'Offers/Kg'
      offprkgcal,
      @EndUserText.label: 'FX/Pcs'
      usdprpccal,
      @EndUserText.label: 'FX/MT'
      usdprmtcal,
      @EndUserText.label: 'Price/Lb'
      prcprlbcal,
      @EndUserText.label: 'Agreed IncoTerm'
      agreedincoterm,
      @EndUserText.label: 'Freight Amount'
      freightchrg,
      @EndUserText.label: 'Freight/Kg in FX'
      frghtkgFX,
      @EndUserText.label: 'Freight/Pc'
      frghtpc,
      @EndUserText.label: 'Part Price/Pc (FX)'
      partpcs,
      @EndUserText.label: 'INR/Kg'
      inrkg,
      @EndUserText.label: 'FX/Kg'
      FXkg,
      @EndUserText.label: 'Freight Remarks'
      freightrmrks


}
