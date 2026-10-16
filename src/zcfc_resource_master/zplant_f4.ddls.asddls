@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Help for Plant'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPlant_F4 
  as select distinct from I_SupplierCompanyByPlant
    association [0..*] to I_PlantStdVH as _name 
      on $projection.plant = _name.Plant
{
    key Plant as plant,
    _name.PlantName
}

where CompanyCode = '1000';

