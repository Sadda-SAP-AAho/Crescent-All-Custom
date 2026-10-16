@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Help for Resource'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZResource_F4_Help as select from zrsrc_mastr_head
{
  key resource_code as Resource_code,
  resource_name    as Resource_name,
 @UI.selectionField: [{ position: 10 }] 
  plant
}
