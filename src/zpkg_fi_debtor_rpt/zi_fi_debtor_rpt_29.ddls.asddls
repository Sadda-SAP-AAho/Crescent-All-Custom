@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtor Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_29

  as select distinct from ZV_EXPORTREG_1     as a

    inner join            ZI_FI_DEBTOR_RPT_9 as m on m.ReferenceSDDocument = a.ReferenceSDDocument

{

  key a.BillingDocument,
      max(m.Etadt)    as Etadt,
      max(m.Etddt)    as Etddt,
      max(m.Empretdt) as Empretdt
}

group by
  a.BillingDocument
