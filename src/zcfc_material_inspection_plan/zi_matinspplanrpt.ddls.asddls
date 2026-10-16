@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Inspection Report Test'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MATINSPPLANRPT
  as select distinct from I_InspPlnMatlAssgmtVersion_2 as b
    left outer join       I_InspPlanOpCharcVersion_2   as a on a.InspectionPlanGroup = b.InspectionPlanGroup
    left outer join       I_BusinessUserBasic          as c on a.CreatedByUser = c.UserID
    left outer join       I_Product                    as d on b.Material = d.Product
    left outer join       I_ProductTypeText            as e on  d.ProductType = e.ProductType
                                                            and e.Language    = 'E'
    left outer join       I_ProductGroupText_2         as f on  d.ProductGroup = f.ProductGroup
                                                            and f.Language     = 'E'
    left outer join       I_Plant                      as g on b.Plant = g.Plant
    left outer join       I_ProductText                as h on d.Product = h.Product

{
  key      b.Material                                                                  as MaterialCode,
  key      h.ProductName                                                               as MaterialDescription,
  key      d.ProductType                                                               as MaterialType,
  key      e.MaterialTypeName                                                          as MaterialTypeDescription,
  key      d.ProductGroup                                                              as MaterialGroup,
  key      f.ProductGroupName                                                          as MaterialGroupDescription,
  key      a.InspectionPlanGroup                                                       as KeyforTaskListGroup,
  key      a.BOOCharacteristic                                                         as Characteristic,
           a.ValidityStartDate                                                         as ValidFromDate,
           a.ValidityEndDate                                                           as Validtodate,
           a.InspectionSpecificationPlant                                              as Plant,
           g.PlantName                                                                 as Plnt,
           a.InspectionSpecification                                                   as MasterIC,
           a.InspSpecIsQuantitative                                                    as QuantitativeCharacteristic,
           ( case when a.InspSpecIsSelectedSetRequired = 'X' then 'YES' else 'NO' end) as Charattribute,
           a.InspectionSpecificationUnit                                               as UnitofMeas,
           a.InspSpecTargetValue                                                       as TargetValue,
           a.InspSpecUpperLimit                                                        as UpperSpecificationLimit,
           a.InspSpecLowerLimit                                                        as LowerSpecificationLimit,
           a.SelectedCodeSet                                                           as CodeGrpSelSet,
           c.PersonFullName                                                            as UseWhoCreatedRecord,
           a.CreationDate                                                              as CreatedOn,
           a.LastChangedByUser                                                         as ChangedBy,
           a.LastChangeDate                                                            as ChangedOn


}
