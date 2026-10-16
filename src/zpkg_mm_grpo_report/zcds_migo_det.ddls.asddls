@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for MIGO Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_MIGO_DET
  as select from I_MaterialDocumentItem_2
{
  key $session.client as mandt_1,
  key MaterialDocument,
  key MaterialDocumentItem,
  key MaterialDocumentYear
}
