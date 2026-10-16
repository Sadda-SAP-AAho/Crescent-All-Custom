@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Pattern of Casting Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PAT_CASTMAT_F4 
as select from zdt_pp_matinffld
{
    key product,
    key castcode1 as castcode
}
where castcode1 is not initial
group by product, castcode1
union all
select from zdt_pp_matinffld
{
    key product,
    key castcode2 as castcode
}
where castcode2 is not initial
group by product, castcode2
union all
select from zdt_pp_matinffld
{
    key product,
    key castcode3 as castcode
}
where castcode3 is not initial
group by product, castcode3
