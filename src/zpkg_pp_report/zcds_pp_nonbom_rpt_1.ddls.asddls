@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_NONBOM_RPT_1
  as select from    I_MaterialDocumentItem_2   as a
    inner join      I_Product                  as d on d.Product = a.Material
    inner join      I_MaterialDocumentHeader_2 as c on  c.MaterialDocument     = a.MaterialDocument     //new
                                                    and c.MaterialDocumentYear = a.MaterialDocumentYear //new
    inner join      ZI_CONF_HDR                as b on b.Shpflrno = c.MaterialDocumentHeaderText        //new
    left outer join zdt_pp_matinffld           as e on e.product = a.Material //new
  // inner join      ZI_CC_DEPT                 as g on g.Kostl = b.Dept
    inner join      ZI_CC_TYPE                 as g on g.Kostl = b.Dept
{
  key       a.PostingDate,
            // key      cast( b.Dept as kostl )                                   as Dept, //new
  key       g.Cctype, // g.Dept,
  key       a.Plant,  //new
  key       e.qtyperbox,   //new
  key       e.typeofmould, //new
            @Semantics.quantity.unitOfMeasure: 'WeightUnit'
  key       d.NetWeight, //new
  key       d.WeightUnit, //new
  key       case when d.ProductGroup = 'Z025' then 'CASTING'
              when d.ProductGroup = 'Z021' then 'MELTING' else '' end as consbase,

            d.WeightUnit                                              as MaterialBaseUnit,
            @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
            sum( case when d.ProductGroup = 'Z025'
                      then case when a.GoodsMovementType =  '101' then cast( ( a.QuantityInBaseUnit ) as abap.quan( 13, 3 ) )
                                when a.GoodsMovementType =  '102' then cast( ( -1 * a.QuantityInBaseUnit ) as abap.quan( 13, 3 ) ) end
                      when d.ProductGroup = 'Z021'
                      then case when a.GoodsMovementType =  '101' then cast( ( a.QuantityInBaseUnit ) as abap.quan( 13, 3 ) )
                                when a.GoodsMovementType =  '102' then cast( ( -1 * a.QuantityInBaseUnit ) as abap.quan( 13, 3 ) ) end
                      else cast( 0 as abap.quan( 13, 3 ) ) end )      as production


}
where
  (
       a.GoodsMovementType =  '101'
    or a.GoodsMovementType =  '102'
  )
  // and  a.GoodsMovementIsCancelled <> 'X'
  and(
       a.Plant             =  '1100'
    or a.Plant             =  '1200'
    or a.Plant             =  '1300'
    or a.Plant             =  '1400'
  )

  //new
  and(
       a.StorageLocation   =  'SASG'
    or a.StorageLocation   =  'KUSG'
    or a.StorageLocation   =  'BGSG'
    or a.StorageLocation   =  'BASG'
  )
  //new

  and(
       d.ProductGroup      =  'Z025'
    or d.ProductGroup      =  'Z021'
  )
  and  a.Material          <> 'CS1TESTBAR'
  and  a.Material          <> 'CS1TESTBAR-DI'
  and  a.Material          <> 'CS1TESTBAR-VAC'
  and  a.Material          <> 'MT00019N'

group by
  a.PostingDate,
  d.ProductGroup,
  d.WeightUnit,
  a.Plant,
  //  b.Dept,
  //g.Dept,
  g.Cctype,
  e.qtyperbox,
  e.typeofmould,
  d.NetWeight,
  d.WeightUnit
