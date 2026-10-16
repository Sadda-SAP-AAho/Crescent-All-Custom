@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Master'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZCUST_MAST as select from I_Customer
{
@ObjectModel.text.element: ['CustomerName']
@UI.textArrangement: #TEXT_LAST
    key Customer,
  @Semantics.text: true
        CustomerName
};
