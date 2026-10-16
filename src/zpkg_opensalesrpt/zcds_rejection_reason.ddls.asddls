@AbapCatalog.sqlViewName: 'ZV_RREASON'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for rejection reason text'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_REJECTION_REASON
  as select distinct from I_SalesDocumentItem           as a
    left outer join       I_SalesDocumentRjcnReasonText as c on  c.SalesDocumentRjcnReason = a.SalesDocumentRjcnReason
                                                             and c.Language                = 'E'
{
  key a.SalesDocument,
  key a.SalesDocumentItem,
      c.SalesDocumentRjcnReasonName
}
where
  a.SDDocumentRejectionStatus = 'C'
