@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Commercial Invoice'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_COMMERCIALINVOICE_F4 
as select distinct from zdt_comm_hed 

association [1..1] to I_BillingDocument        as _Hed                          on  $projection.commid = _Hed.BillingDocument
{
    key commid,
    _Hed.BillingDocumentDate as BillingDocumentDate
}
