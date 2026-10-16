@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Summary Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_BOMSMRPT
  provider contract transactional_query
  as projection on ZI_BOMSMRPT
{
      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'Customer Code'
  key custcode,
      @EndUserText.label: 'Material Code'
  key matcode,
      @EndUserText.label: 'Material Name'
      matname,
      @EndUserText.label: 'MOC'
      moc,
      @EndUserText.label: 'Sales Employee'
      salesperson,
      @UI.hidden: true
      WeightUnit,
      @EndUserText.label: 'Net Weight'
      NetWeight,
      @EndUserText.label: 'M/C Loss'
      mcloss,
      @EndUserText.label: 'NoOfCavity'
      qtybox,
      @EndUserText.label: 'Type Of Mould'
      typmold,
      @EndUserText.label: 'Bunch Weight'
      bunchwt,
      @EndUserText.label: 'Sq. Mtr'
      sqmtr,
      @EndUserText.label: 'Yield %'
      yield,
      @EndUserText.label: 'Liquid Metal'
      lmmatl,
      @EndUserText.label: 'Metal Price-Pig Iron & Ferro Alloys'
      metalprc,
      @EndUserText.label: 'DI Treatment Cost'
      ditrtcost,
      @EndUserText.label: 'Electricity Cost'
      eleccost,
      @EndUserText.label: 'Total Cost'
      ttlcost,
      @EndUserText.label: 'Packing Matl Cost/Kg-Wood & Metal'
      packmtlcost,
      @EndUserText.label: 'Accessory Cost/Kg'
      accscost,
      @EndUserText.label: 'General Store Cost/Kg'
      genstrcost,
      @EndUserText.label: 'Painting Material Cost/Kg'
      pntmtlcostkg,
      @EndUserText.label: 'Painting Material Cost/Sq mtr'
      pntmtlcostsqm,
      @EndUserText.label: 'Conversion Cost/Kg-Mould(Fur),Charg.,etc'
      convcost,
      @EndUserText.label: 'Labour Cost/Kg-Machining,Drill,etc'
      labrcost,
      @EndUserText.label: 'Labour Cost(Spl. Paint)/Kg'
      labrcostsp,
      @EndUserText.label: 'Rate Per Sq Mtr for Paint Only Labour'
      rateprsqm,
      @EndUserText.label: 'Labour Cost(Grinding)/Kg'
      labrcostgr,
      @EndUserText.label: 'Labour Cost/Kg-Packing,Buffing,Grind,etc'
      labrcostoth,
      @EndUserText.label: 'Labour cost (stores)/Kg'
      labrcoststr,
      @EndUserText.label: 'Melting Loss cost/Kg'
      meltlosscst,
      @EndUserText.label: 'Machine Cost'
      machncst,
      @EndUserText.label: 'Labour Cost(Total)/Kg'
      ttllabcost,
      @EndUserText.label: 'Total Cost/Pcs'
      ttlcstpcs,
      @EndUserText.label: 'Total Cost/Kg'
      ttlcstkg,
      @EndUserText.label: 'Selling Expense'
      ttlselexp
}
