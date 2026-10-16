@AbapCatalog.sqlViewName: 'ZV_SAM2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Custom Sales Invoice Table2'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_CUSTSAMPLE_ITM2
  as select from I_BillingDocument     as a
    inner join   I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
    inner join   ZV_DELDASHPRNT_ITM    as i on  i.DeliveryDocument     = b.ReferenceSDDocument
                                            and i.DeliveryDocumentItem = b.ReferenceSDDocumentItem
{
  key a.BillingDocument,
      i.packmattyp,
      sum(i.netwt)   as snw,
      sum(i.growt)   as sgw,
      sum(i.packqty) as spq
}
where
      b.ReferenceSDDocumentCategory = 'J'
  and a.BillingDocumentType         = 'F8'
group by
  a.BillingDocument,
  i.packmattyp
