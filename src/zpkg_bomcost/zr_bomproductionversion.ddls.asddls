@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{ serviceQuality: #C, sizeCategory: #L, dataClass: #MIXED }
@EndUserText.label: 'BOM Production Version'
define view entity ZR_BOMProductionVersion
  as select from I_ProductionVersion
{
  key Material,
  key Plant,
      min(ProductionVersion) as ProductionVersion
}
where
      ProductionVersionIsLocked = ' '
  and ValidityStartDate         <= $session.system_date
  and ValidityEndDate           >= $session.system_date
group by
  Material,
  Plant
