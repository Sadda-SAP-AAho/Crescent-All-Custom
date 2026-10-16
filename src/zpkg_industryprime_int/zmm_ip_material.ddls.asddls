@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Industry Prime Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_IP_MATERIAL
  as select from    I_Product           as a
    left outer join I_ProductPlantBasic as c on(
      c.Product = a.Product
    )
{
  key a.Product                                                                             as item_code,
      a._Text[ Language = $session.system_language  ].ProductName                           as description,
      a.CreationDate,
      a.LastChangeDate,
      a._ProductGroupText_2[ Language = $session.system_language ].ProductGroupText         as itemgroup,
      a._BaseUnitOfMeasure.UnitOfMeasure_E                                                  as primary_uom_shortform,
      a._BaseUnitOfMeasureText[ Language = $session.system_language ].UnitOfMeasureLongName as primary_uom,
      cast( '' as abap.char(10) )                                                           as secondary_uom,
      cast( '' as abap.char(10) )                                                           as secondary_uom_shortform,
      c.ConsumptionTaxCtrlCode                                                              as hsn,
      c.PlannedDeliveryDurationInDays                                                       as leadtime
}
