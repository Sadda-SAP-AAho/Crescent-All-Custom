@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MAT_CONF_F4 
as select from I_ProductPlantBasic as a
inner join I_ProductText as b on b.Product = a.Product and b.Language = 'E'
inner join I_Product as c on c.Product = a.Product
{   
    left( a.Plant, 2 ) as Plant,
    a.Plant as plant1,
    a.Product as Product,
    b.ProductName as Productname,
    c.ProductGroup as Productgroup
}
