@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Item Selection'
@Metadata.ignorePropagatedAnnotations: true
@UI.presentationVariant: [{sortOrder: [{ by: 'Accountingdocument' ,direction:#DESC }]}]
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_NOSTOITM_F4
  as select distinct from zdt_nostro_itm
{

  key  accountingdocument     as Accountingdocument,
  key  accountingdocumentitem as Accountingdocumentitem,
  key  payterm                as Payterm
}

