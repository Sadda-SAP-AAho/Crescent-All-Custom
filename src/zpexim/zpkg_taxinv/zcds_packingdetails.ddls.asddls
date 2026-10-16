@AbapCatalog.sqlViewName: 'ZV_PKGWT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for pkg no & net weight'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_PACKINGDETAILS as 
select from I_BillingDocument as z
left outer join I_BillingDocumentItem as a on z.BillingDocument = a.BillingDocument
//left outer join ZI_PACKLIST_HDR as c on c.Delivery = a.ReferenceSDDocument                                      
//left outer join ZI_PACKLIST_ITM as b on b.Delivery = a.ReferenceSDDocument
//                                     and b.Posnr = a.ReferenceSDDocumentItem
//                                     and a.ReferenceSDDocumentCategory = 'J'
//                                     and c.Id = b.Id
left outer join ZV_PACKDET as b on b.Delivery = a.ReferenceSDDocument
                                and b.Posnr = a.ReferenceSDDocumentItem
                                and a.ReferenceSDDocumentCategory = 'J'
{
    key z.BillingDocument,
        a.BillingQuantityUnit,
         @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
        sum(b.packqty) as pkg,
         @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
        sum(b.netwt) as netwt
}
//where c.Canind <> 'X'
group by z.BillingDocument,
         a.BillingQuantityUnit
