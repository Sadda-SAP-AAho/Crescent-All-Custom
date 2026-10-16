@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'gst invoice and date in shipment notification'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_GSTINV 
as select  from I_BillingDocumentItemBasic as i 
    left outer join  I_BillingDocument    as j on  j.BillingDocument  =  i.BillingDocument
                                                   and j.AccountingTransferStatus <> 'E'

{
   key i.ReferenceSDDocument,
   key i.ReferenceSDDocumentItem,
       j.BillingDocument,
       j.CreationDate   
}
where j.BillingDocument <> '' and i.BillingDocumentType = 'F8'
group by i.ReferenceSDDocument,
         i.ReferenceSDDocumentItem,
         j.BillingDocument,
         j.CreationDate   


