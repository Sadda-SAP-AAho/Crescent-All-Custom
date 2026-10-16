@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Component Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_BOM_COMP_DETAILS 
  as select distinct from ZTBL_FCTN_BOM_HEAD as a 
    left outer join       ZTBL_FCTN_BOM_ITM  as b on  a.BillOfMaterial = b.BillOfMaterial
                                                  
{
   key a.BillOfMaterial,
   key a.plant,
   key a.Material,
   key b.BillOfMaterialComponent,
       b.ProdOrderIssueLocation as StorageLocation 
}
