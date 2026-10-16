@EndUserText.label: 'F4 Help for GateEntry Cloud'
@ObjectModel.representativeKey: 'GatePass'
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #X
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE,#CDS_MODELING_DATA_SOURCE,#CDS_MODELING_ASSOCIATION_TARGET,#LANGUAGE_DEPENDENT_TEXT]
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@ObjectModel.query.implementedBy: 'ABAP:ZCL_GATEENTRY_F4'
@UI.presentationVariant: [{ sortOrder: [{ by: 'GatePass', direction: #DESC }] }]
define root custom entity ZR_GATEENTRY_CE

{
      @Search       : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @EndUserText.label: 'Gate Entry'
  key GatePass      : abap.char(20);
      @EndUserText.label: 'Purchase Order'
      PurchaseOrder : abap.char(10);

}
