@AbapCatalog.sqlViewName: 'ZVI1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for DocumentRefrence No.'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_DOCREFNO as select from I_BillingDocument
{
    BillingDocument,
    DocumentReferenceID
}
