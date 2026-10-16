@AbapCatalog.sqlViewName: 'ZSV2PI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For Proforma Invoice 2nd Table'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_PROINV_T2 as select from I_BillingDocument as a
            inner join I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
            inner join ZV_DELDASHPRNT_ITM as i on i.DeliveryDocument = b.ReferenceSDDocument
                                               
                                                and i.DeliveryDocumentItem = b.ReferenceSDDocumentItem
//            inner join ZV_DELDASHHDR as j on j.DeliveryDocument = i.DeliveryDocument
{
   key a.BillingDocument,
//    i.DeliveryDocument,
//    i.DeliveryDocumentItem,
    i.packmattyp,
    sum(i.netwt) as snw,
    sum(i.growt) as sgw,
    sum(i.packqty) as spq
 //   sum(i.Qty)  as sqty
}
where b.ReferenceSDDocumentCategory = 'J' and a.BillingDocumentType = 'F8'
group by
   a.BillingDocument,
//   i.DeliveryDocument,
//    i.DeliveryDocumentItem,
     i.packmattyp
