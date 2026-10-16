@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS for FG BOMs List'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZR_FGBOMLIST as select from zdt_fgboms
{
    key plant as Plant,
    key opno as OpNo,
    key fg as FG,
    operation as Operation,
    material as Material
}
