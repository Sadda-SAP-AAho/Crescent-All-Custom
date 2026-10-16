@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contractor - F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CONTRCTR_F4
 as select from I_Supplier
{
    key Supplier as contcode,
    key SupplierFullName as contnm
}
where SupplierAccountGroup = 'ZCNT'
