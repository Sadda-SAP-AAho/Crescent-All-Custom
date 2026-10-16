@EndUserText.label: 'Interface View for NOSTRO Head'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_NOSTRO_hed
  as select from zdt_nostro_hed
  composition [0..*] of ZI_NOSTRO_itm  as _Item
  composition [0..*] of ZI_NOSTRO_ITM2 as _Item2
{
  key id           as Id,
      companycode  as Companycode,
      customer     as Customer,
      customername as Customername,
      refaccdocno  as refaccdocno,
      invoiceno    as Invoiceno,
      postingdate  as Postingdate,
      fiscalyear   as fiscalyear,
      _Item,
      _Item2
}
