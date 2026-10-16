@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SALEDOC as select distinct from C_BillgDocItmPrcgElmntBscDEX_1
{
    key BillingDocument,
    max(SalesDocument) as SALESDOCUMENT
}
group by BillingDocument
