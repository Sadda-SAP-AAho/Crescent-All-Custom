@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Material Group'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_MATGRP_F4
  as select from I_ProductGroupText_2
{
  key ProductGroup,
      ProductGroupText,
      /* Associations */
      _ProductGroup
}

where
  Language = $session.system_language
