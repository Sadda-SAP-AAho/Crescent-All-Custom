@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bill of Material - Multi Level Explosion'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{ serviceQuality: #C, sizeCategory: #L, dataClass: #MIXED }
define view entity ZR_BillOfMaterial_ML
  as select from ZR_BOMProductionVersion as a
{
    key Material,
    key Plant,
    ProductionVersion
}
