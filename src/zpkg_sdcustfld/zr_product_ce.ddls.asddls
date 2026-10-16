@EndUserText.label: 'F4 for Product'
@ObjectModel.representativeKey: 'Product'
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #X
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE,#CDS_MODELING_DATA_SOURCE,#CDS_MODELING_ASSOCIATION_TARGET,#LANGUAGE_DEPENDENT_TEXT]
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PRODUCT_F4'
@UI.presentationVariant: [{ sortOrder: [{ by: 'Product', direction: #DESC }] }]
define root custom entity ZR_PRODUCT_CE 
{
        @Search       : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
        @EndUserText.label: 'Product'
    key Product     : abap.char(40);
        @EndUserText.label: 'Product Name'
        productname : abap.char(100);
        
    
}
