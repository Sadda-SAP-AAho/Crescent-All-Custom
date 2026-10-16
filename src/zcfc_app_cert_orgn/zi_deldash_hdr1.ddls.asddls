@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Copy for Deldash'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DELDASH_HDR1  as select from I_BillingDocumentItem as a left outer join ZI_DELDASH_HDR as b 
on a.ReferenceSDDocument = b.Delivery 
{



key a.BillingDocument,
    a.BillingDocumentItem,
             b.Cusmar,
             b.Contno,
             b.Pol,
             b.Pod,
             b.Findes,
             b.Por,
             b.Delmode,
             b.Coo,
             b.Cod,
             b.Shiptype
}group by a.BillingDocument, a.BillingDocumentItem, b.Cusmar,b.Contno, b.Pol,
             b.Pod,
             b.Findes,
             b.Por,
             b.Delmode,
              b.Coo,
              b.Cod,
              b.Shiptype
               
