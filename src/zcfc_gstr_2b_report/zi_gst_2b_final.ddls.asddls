@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST 2B Final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GST_2B_FINAL
  as select distinct from ZI_GST_2B_FINAL_1

{
  key Location,
  key GSTMonth,
  key rowno,
      Type,
      suppgstn,
      lglname,
      invno,
      invtyp,
      invdate,
      invval,
      placesupply,
      revcharge,
      rateperc,
      taxval,
      intgrtax,
      centraltax,
      stateuttax,
      cess,
      gstrperiod,
      gstrfildate,
      itcavail,
      reason,
      apptaxrate,
      JENo,
      JERefNo,
      Vendor2BRefNo,
      TaxValue,
      TaxCode,
      IGSTAmt,
      CGSTAmt,
      SGSTAmt,
      ISDAmt,
      ReverseAmt,
      Difference,
      ( case when ( Difference >= -10 and Difference <= 10 ) then 'Match' else 'Not Match' end  ) as Status
}
