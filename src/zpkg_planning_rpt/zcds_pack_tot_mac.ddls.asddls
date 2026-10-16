@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List wise Short - Machine Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PACK_TOT_MAC 
as select from    zdt_bomdet          as a
left outer join   zdt_bomdet          as c on  c.hedmaterial  = a.hedmaterial
                                          and  c.plant        = a.plant
                                          and  c.component    = a.parent
                                          and  c.productgroup = 'Z028'
left outer join ZCDS_PLANING_RPT_V2   as b  on b.Product = c.component
                                           and b.Plant = c.plant                                          

{
    a.hedmaterial,
    a.component,
    a.plant,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    b.qty as spstck,
    b.MaterialBaseUnit
}
where a.productgroup = 'Z026'
