@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Posting Date(Max)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_POSTINGADATE
  as select distinct from ZI_SHPEXPRPT_1
{
  key Commid,
  key ReferenceDocument,
  key SupplierMaterialNumber,
      Servicepo,
      Servicepoline,

      max(PostingDate) as PostingDate

}
group by
  Commid,
  ReferenceDocument,
  SupplierMaterialNumber,
  Servicepo,
  Servicepoline
