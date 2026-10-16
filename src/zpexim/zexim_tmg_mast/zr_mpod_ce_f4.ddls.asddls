@EndUserText.label: 'Port of Discharge(F4)'
@ObjectModel.representativeKey: 'Podcode'
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #X
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE,#CDS_MODELING_DATA_SOURCE,#CDS_MODELING_ASSOCIATION_TARGET,#LANGUAGE_DEPENDENT_TEXT]
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MPOD_F4'
@UI.presentationVariant: [{ sortOrder: [{ by: 'Podcode', direction: #DESC }] }]
define root custom entity ZR_MPOD_CE_F4
{
      @Search     : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @EndUserText.label: 'POD COde'
  key Podcode     : char10;
      @EndUserText.label: 'POD Name'
      podcodename : char20;
}
