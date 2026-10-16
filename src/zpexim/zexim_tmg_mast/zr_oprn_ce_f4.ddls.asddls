@EndUserText.label: 'Operation(F4)'
@ObjectModel.representativeKey: 'zopd'
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #X
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE,#CDS_MODELING_DATA_SOURCE,#CDS_MODELING_ASSOCIATION_TARGET,#LANGUAGE_DEPENDENT_TEXT]
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@ObjectModel.query.implementedBy: 'ABAP:ZCL_OPRN_F4'
@UI.presentationVariant: [{ sortOrder: [{ by: 'zopd', direction: #DESC }] }]
define root custom entity ZR_OPRN_CE_F4
{
      @Search     : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }

      @EndUserText.label: 'Operation Name'
  key zopd : char30;
      @EndUserText.label: 'Operation Code'
      zopn : char10;

}
