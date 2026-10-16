@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtor Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_28

  as select distinct from I_BillingDocument     as a

    inner join            I_BillingDocumentItem as b on  b.BillingDocument     = a.BillingDocument
                                                     and b.BillingDocumentItem = '000010'

{

  key a.BillingDocument,
      a.BillingDocumentType,
      b.Division,
      b.ProductGroup,
      b.SDDocumentReason

}
