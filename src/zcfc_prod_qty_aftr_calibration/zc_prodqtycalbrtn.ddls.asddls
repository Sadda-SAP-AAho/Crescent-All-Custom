@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Qty after Calibration'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_PRODQTYCALBRTN
  as select from ZI_PRODQTYCALBRTN
{
      @EndUserText.label: 'Material No'
      @Search.defaultSearchElement: true
  key Material,
      @EndUserText.label: 'Material Description'
  key Material_Desc,
      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'MOC'
      MOC,
      @EndUserText.label: 'Customer'
      Customer,
      @EndUserText.label: 'Calibration Date'
      Calibration_Dt,
      @EndUserText.label: 'Calibration Date'
      Qtyperbox,
      @UI.hidden: true
      WeightUnit,
      @EndUserText.label: 'Unit Weight'
      Unit_Wt,
      @UI.hidden: true
      EntryUnit,
      @EndUserText.label: 'Total Quantity'
      Total_Qty,
      @EndUserText.label: 'Total Weight'
      Total_Wt

}
