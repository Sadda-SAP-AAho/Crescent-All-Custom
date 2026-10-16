@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for paymentrunid'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PAYMENTRUNID
  as select from I_PaymentProposalPayment as A
{
  key   PayingCompanyCode,
  key   PaymentDocument,
  max(PaymentRunDate ) as PAYMENTRUNDATE
 }
where FinancialAccountType = 'K'
group by
  PayingCompanyCode,
  PaymentDocument
