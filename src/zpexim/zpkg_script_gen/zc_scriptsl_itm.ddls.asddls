@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View of Script Sales Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity zc_scriptsl_itm 
as projection on zi_scriptsl_itm
{
    key id,
    key item,
    @EndUserText.label: 'FI Document'
    accdocno,
     @EndUserText.label: 'Script Sales Number'
    scriptsalesno,
     @EndUserText.label: 'Script Sales Date'
    scriptsalesdate,
    @EndUserText.label: 'Script Number'
    scriptno,
    @EndUserText.label: 'Script Date'
    scriptdate,
    @EndUserText.label: 'SAC Code'
    saccode,
    @EndUserText.label: 'Currency'
    currency,
    @Semantics.amount.currencyCode: 'currency'
    @EndUserText.label: 'Realization Amount'
    realizationamt,
    @EndUserText.label: 'Rate in %'
    Rate,
    @Semantics.amount.currencyCode: 'currency'
    @EndUserText.label: 'Saleable Value'
    saleablevalue,
    @EndUserText.label: 'Customer Code'
    customer,
    @EndUserText.label: 'Customer Name'
    customername,
    @EndUserText.label: 'Sales Flag'
    salesflag,
    @EndUserText.label: 'FI Document cancelled'
    cancelledaccdocno,
    /* Associations */
    _Head : redirected to parent zc_scriptsl_hdr
}
