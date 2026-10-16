@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Bank Vendor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_VEND_BANK_1
  as select from I_BusinessPartnerBank as a
    inner join   I_Supplier            as b on a.BusinessPartner = b.Supplier
{
  key a.BusinessPartner,
      min(a.BankIdentification) as BankIdentification
}
group by
  a.BusinessPartner
