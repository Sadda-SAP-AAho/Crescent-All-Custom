@AbapCatalog.sqlViewName: 'ZCDS_HV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: ''
define view ZCDS_HEDVIEW
  as select distinct from zdt_packlist_hdr as a 
 inner join        I_BillingDocumentItem       as q on a.delivery =  q.ReferenceSDDocument
 inner join        I_BillingDocument           as r on r.BillingDocument = q.BillingDocument  
{
  a.delivery,
  q.CreationDate,
  r.BillingDocument,
  r.DocumentReferenceID
}
where r.BillingDocumentType = 'F8' and r.AccountingPostingStatus <> 'E' and a.canind = ''
group by
  a.delivery,
  q.CreationDate,
  r.BillingDocument,  
  r.DocumentReferenceID
