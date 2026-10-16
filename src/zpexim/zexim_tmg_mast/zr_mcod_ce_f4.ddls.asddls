@EndUserText.label: 'Country of Destination(F4)'
@ObjectModel.representativeKey: 'Codcode'
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #X
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE,#CDS_MODELING_DATA_SOURCE,#CDS_MODELING_ASSOCIATION_TARGET,#LANGUAGE_DEPENDENT_TEXT]
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MCOD_F4'
@UI.presentationVariant: [{ sortOrder: [{ by: 'Codcode', direction: #DESC }] }]
define root custom entity ZR_MCOD_CE_F4
{
      @Search    : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @EndUserText.label: 'COD Code'
  key Codcode    : char10;
      @EndUserText.label: 'COD Name'
      Codcodenam : char20;
}
