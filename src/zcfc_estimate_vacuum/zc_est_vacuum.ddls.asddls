@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View of Estimate Vacuum Reg'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_EST_VACUUM
  provider contract transactional_query
  as projection on ZI_EST_VACUUM
{
      @UI.hidden: true
  key id,
      @EndUserText.label: 'Material code'
  key matcd,
      @EndUserText.label: 'Rejection'
      rejection,
      @EndUserText.label: 'Tolerance'
      tolerance,
      @EndUserText.label: 'Margin %'
      margin,
      @EndUserText.label: 'Margin INR'
      amtmrgn,
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
      @EndUserText.label: 'Drill/FACING( CONVENTIONAL)'
      drillperfacing,
      @EndUserText.label: 'Surface Area'
      srfcarea,
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
      @EndUserText.label: 'Paint (Labour + Material)-Primer Cost'
      paintprcst,
      @EndUserText.label: 'Selling Expenses'
      sellexpn,
      @EndUserText.label: 'Accessories cavity'
      acccavity,
      @EndUserText.label: 'Exchange Rate'
      exchngrt,
      @EndUserText.label: 'Currency'
      curr,
      @EndUserText.label: 'Packaging Cost'
      packngcst,
      @EndUserText.label: 'Core Cost Cavity'
      corecstcav

}
