@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Material Master CDS'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_MATMASTERCDS
  provider contract transactional_query
  as projection on ZI_MATMASTERCDS

{
      @EndUserText.label: 'Material No'
      @Search.defaultSearchElement: true
  key MaterialNo,
      @UI.hidden: true
  key PlantCode,
      @UI.hidden: true
  key PriceCntrl,
      @UI.hidden: true
  key StorageLocation,
      @EndUserText.label: 'Description'
      Description,
      @EndUserText.label: 'Customer Material No'
      MatByCust,
      @EndUserText.label: 'Subsidiary Company Code'
      SubCompCode,
      @EndUserText.label: 'Create Date'
      CreateDate,
      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Last Updated Date'
      LastChangeDate,
      @EndUserText.label: 'Last Updated By'
      LastChangeBy,
      @EndUserText.label: 'Product Type Code'
      ProductType,
      @EndUserText.label: 'Product Type Name'
      ProductTypName,
      @EndUserText.label: 'Material Group Code'
      MaterialGroup,
      @EndUserText.label: 'Material Group Name'
      MaterialGroupName,
      @EndUserText.label: 'Division'
      Division,
      @EndUserText.label: 'BOM Item'
      BOM_Item,
      @EndUserText.label: 'Component Item'
      BOM_Comp,
      @EndUserText.label: 'UoM'
      UoM,
      @UI.hidden: true
      WeightUnit,
      @EndUserText.label: 'Gross Weight'
      GrossWeight,
      @EndUserText.label: 'Net Weight'
      NetWeight,
      @UI.hidden: true
      UnitofWeight,
      @EndUserText.label: 'Item Category Group'
      ItemCategoryGroup,
      @EndUserText.label: 'Transportation Group'
      TransportationGroup,
      @EndUserText.label: 'Plant Code'
      Plant,
      @EndUserText.label: 'Plant Name'
      PlantName,
      @EndUserText.label: 'Storage Location'
      StorageLoc,
      @EndUserText.label: 'Purchasing Group'
      PurchasingGroup,
      @EndUserText.label: 'Production Storage Location'
      ProductionStorageLocation,
      @EndUserText.label: 'Availability Check'
      AvailabilityCheck,
      @EndUserText.label: 'Procurement Type'
      ProcurementType,
      @UI.hidden: true
      BaseUnit,
      @EndUserText.label: 'Safety Stock'
      SafetyStock,
      @EndUserText.label: 'Maximum Stock'
      MaxStock,
      @EndUserText.label: 'Strategy Group'
      StrtegyGrp,
      @EndUserText.label: 'Consumption Mode'
      ConsumpMode,
      @EndUserText.label: 'Profit Center Code'
      ProfitCenter,
      @EndUserText.label: 'Profit Center Name'
      ProfitCenterName,
      @EndUserText.label: 'Acc. Assignment Code'
      AccAssgnGrpCode,
      @EndUserText.label: 'Acc. Assignment Name'
      AccAssgnGrpName,
      @EndUserText.label: 'Critical Spares'
      CritSpr,
      @EndUserText.label: 'MRP Type'
      MRPType,
      @EndUserText.label: 'MRP Controller'
      MRPController,
      @EndUserText.label: 'MRP Group'
      MRPGrp,
      @EndUserText.label: 'In-House Production (in Days)'
      InHouseProdTime,
      @EndUserText.label: 'Planned Delivery Time (in Days)'
      PlannedDelTime,
      @EndUserText.label: 'Lot Size Procedure'
      LotSizeProc,
      @EndUserText.label: 'HSN Code'
      HSN,
      @EndUserText.label: 'HSN Description'
      HSNText,
      @EndUserText.label: 'Prod. Sch. Profile'
      ProductionSchProfile,
      @EndUserText.label: 'Prod. Supervisor'
      ProductionSupervisor,
      @EndUserText.label: 'Serial No. Profile'
      SerialNoPrfle,
      @EndUserText.label: 'Valuation Class'
      ValuationClass,
      @EndUserText.label: 'Price Control'
      PriceControl,
      @UI.hidden: true
      Currency,
      @EndUserText.label: 'Standard Price'
      StandardPrice,
      @EndUserText.label: 'Moving Avg. Price'
      MovingAvgPrice,
      @EndUserText.label: 'Inspection Setup'
      InspSetup,
      @EndUserText.label: 'Inspection Plan Group'
      InspPlanGrp,
      @EndUserText.label: 'Qty/Box'
      QtyPerBox,
      @EndUserText.label: 'Std no of Pcs-Pack'
      PcsPack,
      @EndUserText.label: 'Potential Order Qty per Pattern'
      PoTPat,
      @EndUserText.label: 'Material Crate'
      MatCrate,
      @EndUserText.label: 'Machining Loss'
      MachLoss,
      @EndUserText.label: 'Qty of Pallet-PCD-Box'
      QtyPalPCDBox,
      @EndUserText.label: 'Type of Moulding'
      TypofMould,
      @EndUserText.label: 'Prodn Capacity/Day'
      ProdCapDay,
      @EndUserText.label: 'Calibration Date'
      CalibDate,
      @EndUserText.label: 'Rejection(%)'
      RejPercntg,
      @EndUserText.label: 'MOC'
      MOC,
      @EndUserText.label: 'CFT'
      CFT,
      @EndUserText.label: 'Pallet/PCD/Box Size'
      pltpcdboxsize,
      @EndUserText.label: 'Consumption Base'
      ConBase,
      @EndUserText.label: 'Consumption/Tonne-Kg-CI'
      ConstCI,
      @EndUserText.label: 'Consumption/Tonne-Kg-DI'
      ConstDI,
      @EndUserText.label: 'Consumption/Tonne-Kg-Vac_Kul'
      ConstVacKul,
      @EndUserText.label: 'Consumption/Tonne-Kg-Bag-1'
      ConstBag1,
      @EndUserText.label: 'Consumption/Tonne-Kg-Bag-2'
      ConstBag2,
      @EndUserText.label: 'Consumption/Tonne-Kg-Baroda'
      ConstBaroda,
      @EndUserText.label: 'Micron'
      MICR,
      @EndUserText.label: 'Load Class'
      LoadClass,
      @EndUserText.label: 'No. of Pattern'
      NoofPtn,
      @EndUserText.label: 'Pattern IR Sent'
      PtnIrs,
      @EndUserText.label: '2nd Pattern Approved'
      PtnApp,
      @EndUserText.label: 'Pilot Prod. Approved'
      PilotPrdApp,
      @EndUserText.label: 'Sqr. Mtr.'
      SqMtr,
      @EndUserText.label: 'Sqr. Mtr.-1'
      SqMtr1,
      @EndUserText.label: 'Sqr. Mtr.-2'
      SqMtr2,
      @EndUserText.label: 'Sqr. Mtr.-3'
      SqMtr3,
      @EndUserText.label: 'Chill Weight/Kg'
      ChillWt,
      @EndUserText.label: 'Moulding Line Speed'
      mldlinspd,
      @EndUserText.label: 'Material Long Text'
      matlngtxt,
      @EndUserText.label: 'Customer Material'
      cusmat,
      @EndUserText.label: 'Paint Information'
      paintinfo,
      @EndUserText.label: 'Core/Non-Core Information'
      coreinfo,
      @EndUserText.label: 'Steel Unit Wt.'
      Steel_unit_wt,
      @EndUserText.label: 'Packing Instruction (No.)'
      packinstr,
      @EndUserText.label: 'Customer Code'
      CustCode

}
