@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For Category F4 Bank Charges'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zr_category 
    as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDOM_CATEGORY') {
    key value_low
}

