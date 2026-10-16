@AbapCatalog.sqlViewName: 'ZI_INDENT_DATA'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Indent Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZI_INDENT
  as select from ZI_MATMASTERCDS
{
  key MaterialNo,
      max(MaxStock) as Max_Stock
}
group by
  MaterialNo
