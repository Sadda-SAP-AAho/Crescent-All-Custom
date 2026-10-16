@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Copy of Interface View for Packlist Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PACKLIST_ITEM_V2 as select from I_BillingDocumentItem as a left outer join ZI_PACKLIST_ITM as b 
on a.ReferenceSDDocument = b.Delivery and a.ReferenceSDDocumentItem = b.Posnr 
{



key a.BillingDocument,
    a.BillingDocumentItem,
              b.Wtunit as Wtunit,
              b.Meins as Meins,
              @Semantics.quantity.unitOfMeasure: 'Wtunit'
               sum(cast(b.Growt as abap.dec( 13, 2 ))) as Growt,
           @Semantics.quantity.unitOfMeasure: 'Wtunit'
          sum(cast(b.Netwt as abap.dec( 13, 2 ))) as Netwt,
           @Semantics.quantity.unitOfMeasure: 'Wtunit'
            sum(cast(b.Packqty as abap.dec( 13, 2 )))    as Packqty
}group by a.BillingDocument, a.BillingDocumentItem,b.Meins,b.Wtunit;
