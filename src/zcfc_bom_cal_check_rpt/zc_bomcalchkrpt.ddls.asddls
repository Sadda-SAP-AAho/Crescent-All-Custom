@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Calculation Check Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define root view entity ZC_BOMCALCHKRPT
  provider contract transactional_query
  as projection on ZI_BOMCALCHKRPT
{
      @Search.defaultSearchElement: true
      @Consumption.filter.mandatory: true
      @EndUserText.label: 'Plant'
  key Plant,
      
      @Search.defaultSearchElement: true
      @Consumption.filter.mandatory: true
      @EndUserText.label: 'Header Matl Grp Code'
  key ProductGroup,

      @EndUserText.label: 'Header Matl Code'
  key HeadMatlCode,

      @EndUserText.label: 'Header Matl Name'
  key HeadMatlName,

      @EndUserText.label: 'Header Qty'
  key HeaderQty,

      @EndUserText.label: 'Sqr Mtr'
  key sqmtr,

      @EndUserText.label: 'Component Code'
  key ComponentCode,

      @EndUserText.label: 'Component Name'
      ComponentName,
      
      @EndUserText.label: 'Component Grp Code'
      CompGrpCode,
      
      @EndUserText.label: 'Component Grp Name'
      CompGrpName,

      @EndUserText.label: 'Micron'
      Micron,

      @EndUserText.label: 'Sub Micron'
      SubMicron,

      @EndUserText.label: 'Std Qty'
      StdQty,

      @EndUserText.label: 'BOM Qty-Calculated'
      BOMQtyCal,

      @EndUserText.label: 'BOM Qty-SAP'
      BOMQtySAP,

      @EndUserText.label: 'Difference'
      Difference
}
