@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Master CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MATMASTERCDS
  as select distinct from I_Product                     as a
    left outer join       I_ProductText                 as b on  a.Product  = b.Product
                                                             and b.Language = 'E'
    left outer join       I_UnitOfMeasure               as c on a.BaseUnit = c.UnitOfMeasure
    left outer join       I_ProductPlantBasic           as d on a.Product = d.Product
    left outer join       zdt_pp_matinffld              as f on a.Product = f.product
    left outer join       I_Plant                       as g on d.Plant = g.Plant
    left outer join       I_ProfitCenterText            as h on d.ProfitCenter = h.ProfitCenter
    left outer join       ZI_MATPRICE                   as i on  a.Product = i.MaterialNo
                                                             and d.Plant   = i.PlantCode
    left outer join       ZTBL_FCTN_BOMITEM             as j on  a.Product = j.material
                                                             and d.Plant   = j.plant
    left outer join       I_ProductSupplyPlanning       as k on  a.Product = k.Product
                                                             and d.Plant   = k.Plant
    left outer join       I_CustomerMaterial_2          as l on a.Product = l.Product
    left outer join       I_BusinessUserBasic           as m on m.UserID = a.CreatedByUser
    left outer join       I_BusinessUserBasic           as n on n.UserID = a.LastChangedByUser
    left outer join       ZTBL_FCTN_BOM_COMP            as o on  a.Product = o.BillOfMaterialComponent
                                                             and d.Plant   = o.plant
    left outer join       I_ProductStorageLocationBasic as p on  a.Product = p.Product
                                                             and d.Plant   = p.Plant
    left outer join       I_ProductGroupText_2          as q on  a.ProductGroup = q.ProductGroup
                                                             and q.Language     = 'E'
    left outer join       I_Productplantqtmanagement    as r on  a.Product = r.Product
                                                             and d.Plant   = r.Plant
    left outer join       ZI_MATINSPPLAN                as s on  a.Product = s.Product
                                                             and d.Plant   = s.Plant
    left outer join       I_ProductTypeText_2           as t on  a.ProductType = t.ProductType
                                                             and t.Language    = 'E'
    left outer join       ZI_MATACCASSGNGRP             as u on a.Product = u.Product
    left outer join       I_AE_CnsmpnTaxCtrlCodeTxt     as v on  d.ConsumptionTaxCtrlCode = v.ConsumptionTaxCtrlCode
                                                             and v.Language               = 'E'
                                                             and v.CountryCode            = 'IN'




{
  key a.Product                                                                                             as MaterialNo,
  key d.Plant                                                                                               as PlantCode,
  key i.PriceControl                                                                                        as PriceCntrl,
  key p.StorageLocation                                                                                     as StorageLocation,
      b.ProductName                                                                                         as Description,
      l.MaterialByCustomer                                                                                  as MatByCust,
      a.ProductOldID                                                                                        as SubCompCode,
      a.CreationDate                                                                                        as CreateDate,
      m.PersonFullName                                                                                      as CreatedBy,
      a.LastChangeDate                                                                                      as LastChangeDate,
      n.PersonFullName                                                                                      as LastChangeBy,
      a.ProductType                                                                                         as ProductType,
      t.ProductTypeName                                                                                     as ProductTypName,
      a.ProductGroup                                                                                        as MaterialGroup,
      q.ProductGroupName                                                                                    as MaterialGroupName,
      a.Division                                                                                            as Division,
      ( case when ( a.Product = j.material and d.Plant = j.plant) then 'YES' else 'NO' end )                as BOM_Item,
      ( case when ( a.Product = o.BillOfMaterialComponent and d.Plant = o.plant) then 'YES' else 'NO' end ) as BOM_Comp,
      c.UnitOfMeasure_E                                                                                     as UoM,
      a.WeightUnit                                                                                          as WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.GrossWeight                                                                                         as GrossWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.NetWeight                                                                                           as NetWeight,
      a.WeightUnit                                                                                          as UnitofWeight,
      a.ItemCategoryGroup                                                                                   as ItemCategoryGroup,
      a.TransportationGroup                                                                                 as TransportationGroup,
      g.Plant                                                                                               as Plant,
      g.PlantName                                                                                           as PlantName,
      p.StorageLocation                                                                                     as StorageLoc,
      d.PurchasingGroup                                                                                     as PurchasingGroup,
      d.ProductionInvtryManagedLoc                                                                          as ProductionStorageLocation,
      d.AvailabilityCheckType                                                                               as AvailabilityCheck,
      d.ProcurementType                                                                                     as ProcurementType,
      d.BaseUnit                                                                                            as BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      d.SafetyStockQuantity                                                                                 as SafetyStock,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      k.MaximumStockQuantity                                                                                as MaxStock,
      k.PlanningStrategyGroup                                                                               as StrtegyGrp,
      k.ProdRqmtsConsumptionMode                                                                            as ConsumpMode,
      d.ProfitCenter                                                                                        as ProfitCenter,
      h.ProfitCenterName                                                                                    as ProfitCenterName,
      cast ( u.AccAssgnGrpCode as abap.char( 2 ) )                                                          as AccAssgnGrpCode,
      u.AccAssgnGrpName                                                                                     as AccAssgnGrpName,
      ( case when u.MatGrp3 = '1' then 'Yes' else 'No' end )                                                as CritSpr,
      d.MRPType                                                                                             as MRPType,
      d.MRPResponsible                                                                                      as MRPController,
      k.MRPGroup                                                                                            as MRPGrp,
      k.InHouseProductionTime                                                                               as InHouseProdTime,
      k.PlannedDeliveryDurationInDays                                                                       as PlannedDelTime,
      k.LotSizingProcedure                                                                                  as LotSizeProc,
      d.ConsumptionTaxCtrlCode                                                                              as HSN,
      v.ConsumptionTaxCtrlCodeText1                                                                         as HSNText,
      d.ProductionSchedulingProfile                                                                         as ProductionSchProfile,
      d.ProductionSupervisor                                                                                as ProductionSupervisor,
      d.SerialNumberProfile                                                                                 as SerialNoPrfle,
      i.ValuationClass                                                                                      as ValuationClass,
      i.PriceControl                                                                                        as PriceControl,
      i.Currency                                                                                            as Currency,
      @Semantics.amount.currencyCode: 'Currency'
      i.StandardPrice                                                                                       as StandardPrice,
      @Semantics.amount.currencyCode: 'Currency'
      i.MovingAvgPrice                                                                                      as MovingAvgPrice,
      r.ProductPlantHasInspectionSetup                                                                      as InspSetup,
      ( case when r.ProductPlantHasInspectionSetup is not initial then s.InspPlanGrp end )                  as InspPlanGrp,
      f.qtyperbox                                                                                           as QtyPerBox,
      f.pcspack                                                                                             as PcsPack,
      f.potpat                                                                                              as PoTPat,
      f.matcrawt                                                                                            as MatCrate,
      f.machloss                                                                                            as MachLoss,
      f.qtypalpcdbox                                                                                        as QtyPalPCDBox,
      f.typeofmould                                                                                         as TypofMould,
      f.prodcapcday                                                                                         as ProdCapDay,
      f.calibdate                                                                                           as CalibDate,
      f.rejpercntg                                                                                          as RejPercntg,
      f.moc                                                                                                 as MOC,
      f.cft                                                                                                 as CFT,
      f.pltpcdboxsize                                                                                       as pltpcdboxsize,
      f.consbase                                                                                            as ConBase,
      f.constci                                                                                             as ConstCI,
      f.constdi                                                                                             as ConstDI,
      f.constvackul                                                                                         as ConstVacKul,
      f.constbag1                                                                                           as ConstBag1,
      f.constbag2                                                                                           as ConstBag2,
      f.constbaroda                                                                                         as ConstBaroda,
      f.micr                                                                                                as MICR,
      f.loadclass                                                                                           as LoadClass,
      f.noofptn                                                                                             as NoofPtn,
      f.ptnirs                                                                                              as PtnIrs,
      f.ptnapp                                                                                              as PtnApp,
      f.pilotprdapp                                                                                         as PilotPrdApp,
      f.sqmtr                                                                                               as SqMtr,
      f.sqmtr1                                                                                              as SqMtr1,
      f.sqmtr2                                                                                              as SqMtr2,
      f.sqmtr3                                                                                              as SqMtr3,
      f.chillwt                                                                                             as ChillWt,
      f.mldlinspd                                                                                           as mldlinspd,
      f.matlngtxt                                                                                           as matlngtxt,
      f.cusmat                                                                                              as cusmat,
      f.paintinfo                                                                                           as paintinfo,
      f.coreinfo                                                                                            as coreinfo,
      f.steel_unit_wt                                                                                       as Steel_unit_wt,
      f.packinstr                                                                                           as packinstr,
      f.cuscode                                                                                             as CustCode

}
where
  a.CrossPlantStatus <> '05'
