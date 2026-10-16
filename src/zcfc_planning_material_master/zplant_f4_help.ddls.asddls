@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant f4 help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPlant_F4_Help
//  with parameters p_mat: matnr
  as select from I_ProductPlantBasic association[0..1] to I_PlantStdVH as _name on $projection.Plant = _name.Plant 
{

    key Plant,
    _name.PlantName,
@UI.selectionField: [{ position: 10 }]
Product
}
//where $parameters.p_mat = '' or Product = $parameters.p_mat;


