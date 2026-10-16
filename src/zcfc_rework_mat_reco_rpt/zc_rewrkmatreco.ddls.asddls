@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rework Material Reco Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_REWRKMATRECO
  provider contract transactional_query
  as projection on ZI_REWRKMATRECO
{
      @EndUserText.label: 'Production Order No'
  key ProdOrdrNo,
      @UI.hidden: true
  key Plant,
      @UI.hidden: true
  key Sl,
      @UI.hidden: true
  key Comp,
      @EndUserText.label: 'Release Date'
      OrdrActRelDate,
      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Creation Date'
      CreationDate,
      @EndUserText.label: 'Last Updated By'
      LastUptBy,
      @EndUserText.label: 'Last Updated Date'
      LastUptDate,
      @EndUserText.label: 'Plant Code'
      PlantCode,
      @EndUserText.label: 'Plant Name'
      PlantName,
      @EndUserText.label: 'Profit Center'
      ProfitCenterCode,
      @EndUserText.label: 'Profit Center Name'
      ProfitCenterName,
      @EndUserText.label: 'Sl No'
      SlNo,
      @EndUserText.label: 'Component No'
      CompNo,
      @EndUserText.label: 'Component Description'
      CompDesc,
      @EndUserText.label: 'Component Group'
      CompGrp,
      @UI.hidden: true
      BaseUnit,
      @EndUserText.label: 'Component-Planned Qty'
      CompPlanedQty,
      @EndUserText.label: 'Component-Issued Qty'
      CompIssuedQty,
      @UI.hidden: true
      WeightUnit,
      @EndUserText.label: 'Componet Net Unit Wt-Kg'
      CompNetUnitWt,
      @EndUserText.label: 'Componet Net  Wt-Kg'
      CompNetWt,
      @EndUserText.label: 'Material Document No'
      MatlDocNo,
      @EndUserText.label: 'Material Document Posting Date'
      MatlDocPostDt,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Amt in Local Currency'
      AmtinLocCurr,
      @EndUserText.label: 'Movement Type'
      MovementType,
      @EndUserText.label: 'Dr/Cr Indicator'
      DrCrIndiCator,
      @EndUserText.label: 'GL Code'
      GlCode,
      @EndUserText.label: 'GL Name'
      GLName
}
