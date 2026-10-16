@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Information Dashboard'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_MATFLD
  provider contract transactional_query
  as projection on ZI_MATFLD
{
      @EndUserText.label: 'Id'
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Material'
  key Product,
      @EndUserText.label: 'Material Description'
      Productdesc,
      @EndUserText.label: 'Qty Per Box'
      Qtyperbox,
      @EndUserText.label: 'Sub Resource Code'
      Subcode,
      @EndUserText.label: 'Std no of Pcs-Pack'
      Pcspack,
      @EndUserText.label: 'Potential Order Qty per Pattern'
      Potpat,
      @EndUserText.label: 'Sq. Mtr'
      Sqmtr,
      @EndUserText.label: 'Metal Crate Wt'
      Matcrawt,
      @EndUserText.label: 'Machining Loss'
      Machloss,
      @EndUserText.label: 'Qty of Pallet-PCD-Box'
      Qtypalpcdbox,
      @EndUserText.label: 'Type of Molding'
      @UI.hidden: true
      Typeofmouldc,
      @EndUserText.label: 'Type of Molding'
      Typeofmould,      
      @EndUserText.label: 'Prodn Capacity/ Day'
      Prodcapcday,
      @EndUserText.label: 'Qty of Bolt/Unit Consumed'
      Qtyboltunitcons,
      @EndUserText.label: 'Calibration Date'
      Calibdate,
      @EndUserText.label: 'Rejection Percentage'
      Rejpercntg,
      @EndUserText.label: 'Item Paint Information'
      @UI.hidden: true
      Itempnt,
      @EndUserText.label: 'MOC'
      moc,
      @EndUserText.label: 'CFT'
      Cft,
      @EndUserText.label: 'Pallet/PCD/Box Size'
      Pltpcdboxsize,
      @EndUserText.label: 'Bolt Size'
      Boltsize,
      @EndUserText.label: 'Consumption Base'
      Consbase,
      @EndUserText.label: 'Consumption / Tonne - Kg-DI'
      Constdi,
      @EndUserText.label: 'Consumption/Tonne-Kg-CI'
      Constci,
      @EndUserText.label: 'Consumption/Tonne-Kg-Bag-1'
      Constbag1,
      @EndUserText.label: 'Consumption/Tonne-Kg-Bag-2'
      Constbag2,
      @EndUserText.label: 'Consumption/Tonne-Kg-Baroda'
      Constbaroda,
      @EndUserText.label: 'Consumption/Tonne-Kg-Vac_Kul'
      Constvackul,
      @EndUserText.label: 'Micron'
      Micr,
      @EndUserText.label: 'Sub-Micron'
      Submicron,
      @EndUserText.label: 'Standard Qty.'
      Stdqty,
      @EndUserText.label: 'Load Class'
      @UI.hidden: true
      Loadclass,
      @EndUserText.label: 'Customer Code'
      Cuscode,
      @EndUserText.label: 'No. of Pattern'
      Noofptn,
      @EndUserText.label: 'Pattern IR Sent'
      Ptnirs,
      @EndUserText.label: '2nd Pattern Approved'
      Ptnapp,
      @EndUserText.label: 'Pilot Prodn Approved'
      Pilotprdapp,
      @EndUserText.label: 'Sq. Mtr 1'
      Sqmtr1,
      @EndUserText.label: 'Sq. Mtr 2'
      Sqmtr2,
      @EndUserText.label: 'Sq. Mtr 3'
      Sqmtr3,
      @EndUserText.label: 'Chill Weight/Kg'
      Chillwt,
      @EndUserText.label: 'Jig & Fixture 1'
      Jigf1,
      @EndUserText.label: 'Jig & Fixture 2'
      Jigf2,
      @EndUserText.label: 'Casting Item code 1'
      Castcode1,
      @EndUserText.label: 'Casting Item code 2'
      Castcode2,
      @EndUserText.label: 'Casting Item code 3'
      Castcode3,
      @EndUserText.label: 'Part Number'
      Partno,
      @EndUserText.label: 'Drawing Number'
      Drawno,
      @EndUserText.label: 'Art Number'
      Artno,
      @EndUserText.label: 'Moulding Line Speed'
      Mldlinspd,
      @EndUserText.label: 'Material Long Text'
      Matlngtxt,
      @EndUserText.label: 'Customer Material'
      Cusmat,
      @EndUserText.label: 'Paint Information'
      Paintinfo,
      @EndUserText.label: 'Material Sub Code'
      Matsubcode,
      @EndUserText.label: 'Core/Non-Core Information'
      Coreinfo,
      @EndUserText.label: 'Steel Unit Wt.'
      Steel_unit_wt,
      @EndUserText.label: 'Packing Instruction (No.)'
      packinstr,
      @EndUserText.label: 'Last Changed Date'
      Lastchngedt,
      @EndUserText.label: 'last Changed time'
      Lastchnngtm
      
}
