@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for weight of finalpl items'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_WEIGHT 
as select distinct from I_BillingDocument as a 
left outer join I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
                                              and b.ReferenceSDDocumentCategory = 'J'
 
//left outer join zi_finalpack_itm      as c on // c.Id = d.Id and
//                                              c.Delivery = b.ReferenceSDDocument  
//                                           and c.Posnr = b.ReferenceSDDocumentItem
//left outer join zi_finalpack_hdr      as d on d.Id = c.Id 
left outer join ZV_FINALPLDET as c on c.Delivery = b.ReferenceSDDocument
                                and c.Posnr = b.ReferenceSDDocumentItem
{
   key b.BillingDocument,
       c.Delivery,
       c.Posnr,
       c.Meins,
       @Semantics.quantity.unitOfMeasure : 'meins'
       c.netwt,
       @Semantics.quantity.unitOfMeasure : 'meins'
       c.growt
}
// where d.Canind = '' and a.BillingDocumentType = 'F2' 
where a.BillingDocumentType = 'F2'
group by b.BillingDocument,
       c.Delivery,
       c.Posnr,
       c.Meins,
       c.netwt,
       c.growt 
