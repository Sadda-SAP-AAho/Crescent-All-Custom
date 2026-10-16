@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Master Report Test'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_MATMSTRPTTST
  provider contract transactional_query
  as projection on ZI_MATMSTRPTTST
{
      @EndUserText.label: 'Material No'
      @Search.defaultSearchElement: true
  key Product,
      @UI.hidden: true
  key Plant,
      @UI.hidden: true
  key PriceControl,
      @EndUserText.label: 'Description'
      ProductName,
      @EndUserText.label: 'Customer Material No'
      MaterialByCustomer,
      @EndUserText.label: 'Create Date'
      CreationDate,
      @EndUserText.label: 'Created By'
      PersonFullName,
      @EndUserText.label: 'Last Updated Date'
      LastChangeDate,
      @EndUserText.label: 'Last Updated By'
      LastUpdatedBy,
      @EndUserText.label: 'Product Type'
      ProductType,
      @EndUserText.label: 'Material Group Code'
      ProductGroup,
      @EndUserText.label: 'Division'
      Division,
      @EndUserText.label: 'UoM'
      UOM,
      @EndUserText.label: 'Unit of Weight'
      WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      @EndUserText.label: 'Gross Weight'
      GrossWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      @EndUserText.label: 'Net Weight'
      NetWeight,
      @EndUserText.label: 'Unit of Weight'
      WeightUnit   as WhtUnit,
      @EndUserText.label: 'Unit of Weight'
      WeightUnit   as WtUnit,
      @EndUserText.label: 'Item Category Group'
      ItemCategoryGroup,
      @EndUserText.label: 'Transportation Group'
      TransportationGroup,
      @EndUserText.label: 'Plant Code'
      PlantCode,
      @EndUserText.label: 'Plant Name'
      PlantName,
      @EndUserText.label: 'Purchasing Group'
      PurchasingGroup,
      @EndUserText.label: 'Production Storage Location'
      ProductionInvtryManagedLoc,
      @EndUserText.label: 'Availability Check'
      AvailabilityCheckType,
      @EndUserText.label: 'Procurement Type'
      ProcurementType,
      @EndUserText.label: 'Production Storage Location'
      BaseUnit,
      @EndUserText.label: 'Safety Stock'
      SafetyStockQuantity,
      @EndUserText.label: 'Strategy Group'
      PlanningStrategyGroup,
      @EndUserText.label: 'Profit Center Code'
      ProfitCenter,
      @EndUserText.label: 'Profit Center Name'
      ProfitCenterName,
      @EndUserText.label: 'MRP Type'
      MRPType,
      @EndUserText.label: 'MRP Controller'
      MRPResponsible,
      @EndUserText.label: 'MRP Group'
      MRPGroup,
      @EndUserText.label: 'In-House Production (in Days)'
      InHouseProductionTime,
      @EndUserText.label: 'Planned Delivery Time (in Days)'
      PlannedDeliveryDurationInDays,
      @EndUserText.label: 'Lot Size Procedure'
      LotSizingProcedure,
      @EndUserText.label: 'HSN'
      ConsumptionTaxCtrlCode,
      @EndUserText.label: 'Prod. Sch. Profile'
      ProductionSchedulingProfile,
      @EndUserText.label: 'Prod. Supervisor'
      ProductionSupervisor,
      @EndUserText.label: 'Valuation Class'
      ValuationClass,
      @EndUserText.label: 'Price Control'
      PriceControl as PControl,
       @Semantics.amount.currencyCode: 'Currency'
      StandardPrice,
      @EndUserText.label: 'Currency'
      Currency,
       @Semantics.amount.currencyCode: 'Currency'
      @EndUserText.label: 'Moving Avg. Price'
      MovingAvgPrice,
      @EndUserText.label: 'Currency'
      Currency     as curr,
      @EndUserText.label: 'Qty/Box'
      qtyperbox,
      @EndUserText.label: 'Std no of Pcs-Pack'
      pcspack,
      @EndUserText.label: 'Potential Order Qty per Pattern'
      potpat,
      @EndUserText.label: 'Material Crate'
      matcrawt,
      @EndUserText.label: 'Machining Loss'
      machloss,
      @EndUserText.label: 'Qty of Pallet-PCD-Box'
      qtypalpcdbox,
      @EndUserText.label: 'Type of Moulding'
      typeofmould,
      @EndUserText.label: 'Prodn Capacity/Day'
      prodcapcday,
      @EndUserText.label: 'Calibration Date'
      calibdate,
      @EndUserText.label: 'Rejection(%)'
      rejpercntg,
      @EndUserText.label: 'MOC'
      moc,
      @EndUserText.label: 'CFT'
      cft,
      @EndUserText.label: 'Pallet/PCD/Box Size'
      pltpcdboxsize,
      @EndUserText.label: 'Consumption Base'
      consbase,
      @EndUserText.label: 'Consumption/Tonne-Kg-CI'
      constci,
      @EndUserText.label: 'Consumption/Tonne-Kg-DI'
      constdi,
      @EndUserText.label: 'Consumption/Tonne-Kg-Vac_Kul'
      constvackul,
      @EndUserText.label: 'Consumption/Tonne-Kg-Bag-1'
      constbag1,
      @EndUserText.label: 'Consumption/Tonne-Kg-Bag-2'
      constbag2,
      @EndUserText.label: 'Consumption/Tonne-Kg-Baroda'
      constbaroda,
      @EndUserText.label: 'Micron'
      micr,
      @EndUserText.label: 'Load Class'
      loadclass,
      @EndUserText.label: 'No. of Pattern'
      noofptn,
      @EndUserText.label: 'Pattern IR Sent'
      ptnirs,
      @EndUserText.label: '2nd Pattern Approved'
      ptnapp,
      @EndUserText.label: 'Pilot Prod. Approved'
      pilotprdapp,
      @EndUserText.label: 'Sqr. Mtr.'
      sqmtr,
      @EndUserText.label: 'Sqr. Mtr.-1'
      sqmtr1,
      @EndUserText.label: 'Sqr. Mtr.-2'
      sqmtr2,
      @EndUserText.label: 'Sqr. Mtr.-3'
      sqmtr3,
      @EndUserText.label: 'Chill Weight/Kg'
      chillwt,
      @EndUserText.label: 'Customer Code'
      cuscode
}
