@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Multiple Purchase Order By Customer View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_PODRAFTPL 
as select from zdt_packlist_hdr as i 
left outer join I_DeliveryDocument as a on a.DeliveryDocument = i.delivery
inner join I_DeliveryDocumentItem as b on a.DeliveryDocument = b.DeliveryDocument
inner join I_SalesOrder as c on b.ReferenceSDDocument = c.SalesOrder
{ 
     key a.DeliveryDocument,
         i.revision,
         c.PurchaseOrderByCustomer,
         c.CustomerPurchaseOrderDate
}
where i.canind <> 'X'
