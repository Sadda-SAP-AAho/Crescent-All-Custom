@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View of Estimate Vacuum Reg'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_ESTVACREG
  provider contract transactional_query
  as projection on ZI_ESTVACREG
{
      @UI.hidden: true
  key id,
      @EndUserText.label: 'RFQ No'
  key rfqno,
      @EndUserText.label: 'RFQ Date'
      rfqdate,
      @EndUserText.label: 'Material code'
      matcd,
      @EndUserText.label: 'Rejection % (like 1% ~ 0.01)'
      rejection,
      @EndUserText.label: 'Tolerance % (like 3% ~ 0.03)'
      tolerance,
      @EndUserText.label: 'Margin %'
      margin,
//      @EndUserText.label: 'Margin INR'
//      amtmrgn,
      @EndUserText.label: 'Container Weight - Kg'
      cntwgt,
      @EndUserText.label: 'Fixed Cost - Calculated'
      fxdcst_cal,
      @EndUserText.label: 'Fixed Cost - User Entry'
      fxdcst_ue,
      @EndUserText.label: 'Line'
      line,
      @EndUserText.label: 'Box Size D1'
      boxsize1,
      @EndUserText.label: 'Box Size D2'
      boxsize2,
      @EndUserText.label: 'Annual Qty'
      annualqty,
      @EndUserText.label: 'Mould Speed'
      mouldspd,
      @EndUserText.label: 'Required Wt(Kg)'
      reqweight,
      @EndUserText.label: 'No of Cavities'
      noofcav,
      @EndUserText.label: 'Yield'
      yield,
      @EndUserText.label: 'Additional Accessories Cost'
      addacccost,
      @EndUserText.label: 'Machining Cost'
      drillperfacing,
      @EndUserText.label: 'Surface Area'
      srfcarea,
      @EndUserText.label: 'Melting Cost/MT'
      meltingcst,
      @EndUserText.label: 'Charging Cost / MT'
      chrgingcst,
      @EndUserText.label: 'Metal Cost/MT'
      metalcst,
      @EndUserText.label: 'Electricity Cost/Box'
      elccst,
      @EndUserText.label: 'Labour for Molding/Box'
      labmldperbx,
      @EndUserText.label: 'Molding Cost/Box'
      mldcst,
      @EndUserText.label: 'Maintainance Cost/Piece'
      mntcstperpc,
      @EndUserText.label: 'Fettling Cost/Piece'
      fetcstperpc,
      @EndUserText.label: 'Packaging Cost % (like 3% ~ 0.03)'
      packngcst,
      @EndUserText.label: 'Paint (Labour + Material)-Primer Cost'
      paintprcst,
      @EndUserText.label: 'Selling Expenses'
      sellexpn,
      @EndUserText.label: 'Accessories cavity'
      acccavity,
      @EndUserText.label: 'Packaging Rate/Kg'
      packrateperkg,
      @EndUserText.label: 'Exchange Rate'
      exchngrt,
      @EndUserText.label: 'Currency'
      curr,
      @EndUserText.label: 'Core Cost Cavity'
      corecstcav,
      @EndUserText.label: 'Agreed IncoTerm'
      agreedincoterm,
      @EndUserText.label: 'Freight Charge'
      freightchrg,
      @EndUserText.label: 'Freight Remarks'
      freightrmrks,
      @EndUserText.label: 'FCL Weight(Kg)'
      fclwgt

}
