@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base CDS View for Material Grp/Plant'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_MATGRP_MASTER
  as select from I_GoodsMovementCube
{
  key MaterialGroup,
  key Plant

}
where
  MaterialGroup <> ' '
group by
  MaterialGroup,
  Plant
