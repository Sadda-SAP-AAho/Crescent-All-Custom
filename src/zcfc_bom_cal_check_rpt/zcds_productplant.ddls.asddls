@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant Wise Product'
@ObjectModel.dataCategory: #VALUE_HELP

define view entity ZCDS_PRODUCTPLANT
  as select distinct from I_ProductPlantBasic  as a
    inner join            I_Product            as b on a.Product = b.Product
    left outer join       I_ProductGroupText_2 as c on  b.ProductGroup = c.ProductGroup
                                                    and c.Language     = 'E'
{
  key a.Plant,
  key b.ProductGroup,
  key c.ProductGroupName,
  key a.Product

}
