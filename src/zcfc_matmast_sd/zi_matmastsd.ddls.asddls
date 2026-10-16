@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Master SD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MATMASTSD
 as select from I_Product as a
  inner join       I_ProductText                                 as b on  a.Product  = b.Product
                                                                             and b.Language = 'E'
   inner join      I_ProductPlantBasic                           as c on a.Product = c.Product
   left outer join I_ProductSalesDelivery                        as d on a.Product = d.Product    
{
    key a.Product as MatCode,
    key b.ProductName as MatName,
    key c.Plant,
     d.ProductSalesOrg,
     a.Division,
     d.ProductDistributionChnl
    
}
