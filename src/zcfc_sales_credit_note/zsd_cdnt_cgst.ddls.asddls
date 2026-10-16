@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CGST Rate & Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_CDNT_CGST as select from I_BillingDocumentItem as Item


  left outer join I_BillingDocumentItemPrcgElmnt as Elmnt
    on  Item.BillingDocument     = Elmnt.BillingDocument
    and Item.BillingDocumentItem = Elmnt.BillingDocumentItem
    and Elmnt.ConditionType      = 'JOCG' 
 
{  
    key Item.BillingDocument,
    key Item.BillingDocumentItem,

    // CGST Details
    Elmnt.ConditionRateValue as CGST_Rate,
    @Semantics.amount.currencyCode: 'CGST_Currency'
    Elmnt.ConditionAmount    as CGST_Amt,
    Elmnt.ConditionCurrency  as CGST_Currency
    
}
