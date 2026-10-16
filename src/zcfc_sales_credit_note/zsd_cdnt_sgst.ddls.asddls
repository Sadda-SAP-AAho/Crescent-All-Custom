@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SGST Rate & Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_CDNT_SGST as select from I_BillingDocumentItem as Item

  left outer join I_BillingDocumentItemPrcgElmnt as Elmnt
    on  Item.BillingDocument     = Elmnt.BillingDocument
    and Item.BillingDocumentItem = Elmnt.BillingDocumentItem
    and Elmnt.ConditionType      = 'JOSG'  
{
     // Billing document item details
    key Item.BillingDocument,
    key Item.BillingDocumentItem,
    // SGST fields
    Elmnt.ConditionRateValue as SGST_Rate,
    @Semantics.amount.currencyCode: 'SGST_Currency'
    Elmnt.ConditionAmount    as SGST_Amt,
    Elmnt.ConditionCurrency  as SGST_Currency 
} 
