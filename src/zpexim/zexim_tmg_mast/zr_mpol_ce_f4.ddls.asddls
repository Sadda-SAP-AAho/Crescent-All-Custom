@EndUserText.label: 'Port Of Loading(F4)'
@ObjectModel.representativeKey: 'Polcode'
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #X
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE,#CDS_MODELING_DATA_SOURCE,#CDS_MODELING_ASSOCIATION_TARGET,#LANGUAGE_DEPENDENT_TEXT]
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MPOL_F4'
@UI.presentationVariant: [{ sortOrder: [{ by: 'Polcode', direction: #DESC }] }]
define root custom entity ZR_MPOL_CE_F4
{
      @Search    : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @EndUserText.label: 'POL Code'
  key Polcode    : char10;
      @EndUserText.label: 'POL Name'
      polcodename : char20;
}
