@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Group'
@ObjectModel.dataCategory: #VALUE_HELP

define view entity ZCDS_PRODUCTGRP
  as select distinct from I_Product            as a
    inner join            I_ProductGroupText_2 as b on  b.ProductGroup = a.ProductGroup
                                                    and b.Language     = 'E'
{
  key b.ProductGroup,
      b.ProductGroupName
}
