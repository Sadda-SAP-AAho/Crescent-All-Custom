@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'IGST Rate & Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
} 
define view entity ZSD_CDNT_IGST as select from I_BillingDocumentItem as Item

  left outer join I_BillingDocumentItemPrcgElmnt as Elmnt
    on  Item.BillingDocument     = Elmnt.BillingDocument
    and Item.BillingDocumentItem = Elmnt.BillingDocumentItem
    and Elmnt.ConditionType      = 'JOIG'  
{
    // Billing document item details 
    key Item.BillingDocument,
    key Item.BillingDocumentItem,
    // IGST fields
    Elmnt.ConditionRateValue as IGST_Rate,
    @Semantics.amount.currencyCode: 'IGST_Currency'
    Elmnt.ConditionAmount    as IGST_Amt,
    Elmnt.ConditionCurrency  as IGST_Currency
}
