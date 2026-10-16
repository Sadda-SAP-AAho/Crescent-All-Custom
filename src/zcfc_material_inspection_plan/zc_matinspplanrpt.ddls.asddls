@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Inspection Report Test'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_MATINSPPLANRPT
  provider contract transactional_query
  as projection on ZI_MATINSPPLANRPT
{
      @EndUserText.label: 'Material Code'
      @Search.defaultSearchElement: true
  key MaterialCode,
      @EndUserText.label: 'Material Description'
  key MaterialDescription,
      @EndUserText.label: 'Material Type'
  key MaterialType,
      @EndUserText.label: 'Material Type Description'
  key MaterialTypeDescription,
      @EndUserText.label: 'Material Group'
  key MaterialGroup,
      @EndUserText.label: 'Material Group Description'
  key MaterialGroupDescription,
      @EndUserText.label: 'Inspection Plan No'
  key KeyforTaskListGroup,
      @EndUserText.label: 'PlanLine No'
  key Characteristic,
      @EndUserText.label: 'Valid-From Date'
      ValidFromDate,
      @EndUserText.label: 'Valid-to date'
      Validtodate,
     @EndUserText.label: 'Plant Code'
      Plant,
      @EndUserText.label: 'Plant Name'
      Plnt,
      @EndUserText.label: 'Master IC'
      MasterIC,
      @EndUserText.label: 'Quantitative Characteristic'
      QuantitativeCharacteristic,
      @EndUserText.label: 'Qualitative Characterictic'
      Charattribute,
      @EndUserText.label: 'Unit of Meas.'
      UnitofMeas,
      @EndUserText.label: 'Target Value'
      TargetValue,
      @EndUserText.label: 'Upper Specification Limit'
      UpperSpecificationLimit,
      @EndUserText.label: 'Lower Specification Limit'
      LowerSpecificationLimit,
      @EndUserText.label: 'CodeGrp/SelSet'
      CodeGrpSelSet,
      @EndUserText.label: 'User Who Created Record'
      UseWhoCreatedRecord,
      @EndUserText.label: 'Created On'
      CreatedOn,
      @EndUserText.label: 'Changed By'
      ChangedBy,
      @EndUserText.label: 'Changed On'
      ChangedOn
}
