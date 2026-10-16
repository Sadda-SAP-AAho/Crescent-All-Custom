@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FOB Invoice'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_FOB_INV
  as select from I_JournalEntryItem as a
{
  a.AssignmentReference,
  a.AccountingDocument
}
where
      a.AssignmentReference is not initial
  and a.IsReversed          = ''
  and a.IsReversal          = ''
  and a.GLAccount           = '0036400110'

group by
  a.AssignmentReference,
  a.AccountingDocument
