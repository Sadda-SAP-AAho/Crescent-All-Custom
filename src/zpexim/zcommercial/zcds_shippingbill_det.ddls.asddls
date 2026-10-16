@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for shipping bill no & date'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_SHIPPINGBILL_DET 
as select distinct from I_BillingDocument as a
left outer join I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
                                           and b.ReferenceSDDocumentCategory = 'J'
left outer join I_BillingDocumentItem as c on c.ReferenceSDDocument =  b.ReferenceSDDocument
                                           and c.BillingDocumentType     =  'F8'
                                           and a.AccountingPostingStatus <> 'E'
 left outer join       ZR_ShippingBillItemTP      as m on m.Invoice = c.BillingDocument
 left outer join       ZR_ShippingBillTP          as n on n.InternalShipbill = m.InternalShipbill

{
    key c.BillingDocument,
        n.ShippingBill,
        n.ShippingBillDate 
       
        
    
}
