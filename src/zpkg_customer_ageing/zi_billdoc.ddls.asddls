@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BILLDOC as select from I_BillingDocumentItem
{
    key $session.client as aclient,
    key BillingDocument,
    key BillingDocumentItem,
    ReferenceSDDocument
}
