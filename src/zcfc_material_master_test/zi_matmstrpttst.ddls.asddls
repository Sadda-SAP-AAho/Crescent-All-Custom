

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Master Report Test'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MATMSTRPTTST
  as select distinct from I_Product               as a
    left outer join       I_ProductText           as b on a.Product = b.Product
    left outer join       I_CustomerMaterial_2    as c on a.Product = c.Product
    left outer join       I_BusinessUserBasic     as d on a.CreatedByUser = d.UserID
    left outer join       I_BusinessUserBasic     as l on a.LastChangedByUser = l.UserID
    left outer join       I_UnitOfMeasure         as e on a.BaseUnit = e.UnitOfMeasure
    left outer join       I_ProductPlantBasic     as g on a.Product = g.Product
    left outer join       I_Plant                 as f on g.Plant = f.Plant
    left outer join       I_ProductSupplyPlanning as h on  a.Product = h.Product
                                                       and g.Plant   = h.Plant
    left outer join       I_ProfitCenterText      as i on g.ProfitCenter = i.ProfitCenter
    left outer join       ZI_MATPRICE             as j on  a.Product = j.MaterialNo
                                                       and g.Plant   = j.PlantCode
    left outer join       zdt_pp_matinffld        as k on a.Product = k.product


{
  key a.Product,
  key g.Plant,
  key j.PriceControl,
      b.ProductName,
      c.MaterialByCustomer,
      a.CreationDate,
      d.PersonFullName,
      a.LastChangeDate,
      l.PersonFullName  as LastUpdatedBy,
      a.ProductType,
      a.ProductGroup,
      a.Division,
      e.UnitOfMeasure_E as UOM,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.GrossWeight,
      a.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.NetWeight,
      a.WeightUnit      as NtWght,
      a.WeightUnit      as NtWht,
      a.ItemCategoryGroup,
      a.TransportationGroup,
      f.Plant           as PlantCode,
      f.PlantName,
      g.PurchasingGroup,
      g.ProductionInvtryManagedLoc,
      g.AvailabilityCheckType,
      g.ProcurementType,
      g.BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      g.SafetyStockQuantity,
      h.PlanningStrategyGroup,
      g.ProfitCenter,
      i.ProfitCenterName,
      g.MRPType,
      g.MRPResponsible,
      h.MRPGroup,
      h.InHouseProductionTime,
      g.PlannedDeliveryDurationInDays,
      h.LotSizingProcedure,
      g.ConsumptionTaxCtrlCode,
      g.ProductionSchedulingProfile,
      g.ProductionSupervisor,
      j.ValuationClass,
      j.PriceControl    as PControl,
      @Semantics.amount.currencyCode: 'Currency'
      j.StandardPrice,
      j.Currency,
      @Semantics.amount.currencyCode: 'Currency'
      j.MovingAvgPrice,
      j.Currency        as curr,
      k.qtyperbox,
      k.pcspack,
      k.potpat,
      k.matcrawt,
      k.machloss,
      k.qtypalpcdbox,
      k.typeofmould,
      k.prodcapcday,
      k.calibdate,
      k.rejpercntg,
      k.moc,
      k.cft,
      k.pltpcdboxsize,
      k.consbase,
      k.constci,
      k.constdi,
      k.constvackul,
      k.constbag1,
      k.constbag2,
      k.constbaroda,
      k.micr,
      k.loadclass,
      k.noofptn,
      k.ptnirs,
      k.ptnapp,
      k.pilotprdapp,
      k.sqmtr,
      k.sqmtr1,
      k.sqmtr2,
      k.sqmtr3,
      k.chillwt,
      k.cuscode

}
