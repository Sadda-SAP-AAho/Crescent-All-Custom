@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total Value for Comm Inv Split Value'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_COMM_INV_SPLT_VAL_Total as select from ZCDS_final_comm_print2
{
    key Billingdocument
//    sum(Col10) as Col10
}group by Billingdocument;
