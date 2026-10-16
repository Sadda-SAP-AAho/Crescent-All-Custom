@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material wise Production Plant'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_MAT_PROD_PLANT
  as select distinct from zdt_bomdet          as a
    left outer join       I_ProductPlantBasic as b on  b.Product = a.component
                                                   and b.Plant   = a.plant
{
  key (case when b.SpecialProcurementType = '40' then '1100'
            else a.plant end) as Plant,
  key a.hedmaterial

}

union all

select distinct from zdt_bomdet          as a
  left outer join    I_ProductPlantBasic as b on  b.Product = a.hedmaterial
                                              and b.Plant   = a.plant
{
  key (case when b.SpecialProcurementType = '40' then '1100'
            else a.plant end) as Plant,
  key a.hedmaterial

}
