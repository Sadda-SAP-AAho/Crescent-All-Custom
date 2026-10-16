@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Venodor Wise Email'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_VEND_MAIL
  as select from zdt_vend_mail
{
  key id       as Id,
      lifnr    as Lifnr,
      reflifnr as Reflifnr,
      mail1    as Mail1,
      mail2    as Mail2,
      mail3    as Mail3,
      mail4    as Mail4,
      mail5    as Mail5,
      copy     as Copy
}
