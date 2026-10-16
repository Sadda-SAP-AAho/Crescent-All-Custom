@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Copy for Deldash HDR1 View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DELDASH_HDR2 as select from ZI_DELDASH_HDR1
{
    key BillingDocument,
    Cusmar,
    Contno,
    Pol,
    Pod,
    Findes,
    Por,
    Delmode,
    Coo,
    Cod,
    Shiptype
}group by BillingDocument, Cusmar,Contno, Pol,
             Pod,
             Findes,
             Por,
             Delmode,
             Coo,
             Cod,
             Shiptype;
