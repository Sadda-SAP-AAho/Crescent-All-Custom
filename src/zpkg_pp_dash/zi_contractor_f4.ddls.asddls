@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Contractor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CONTRACTOR_F4 
as select from I_Supplier
{
    key Supplier as Zcon,
    key SupplierFullName as Zcod
}
where SupplierAccountGroup = 'ZCNT'
