@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Fixed Cost Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_FIXEDCOST
  provider contract transactional_query
  as projection on ZI_FIXEDCOST
{
      
      @EndUserText.label: 'Parent Item'
      @Search.defaultSearchElement: true
  key Hedmaterial,
      @EndUserText.label: 'Parent Item Name'
  key Head_MatName,
      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'MOC'
  key moc,
      @EndUserText.label: 'Customer Code'
  key cuscode,
      @EndUserText.label: 'Level'
  key Bomlevel,
      @EndUserText.label: 'Child Item'
  key Component,
      @EndUserText.label: 'Child Item Name'
      Child_MatName,
      @EndUserText.label: 'Child Oprn Code'
      Child_Oprn_Code,
      @EndUserText.label: 'Child Operation'
      Child_Oprn,
      @EndUserText.label: 'Parent Qty'
      ParentQty,
      @EndUserText.label: 'Qty Unit'
      Unit,
      @EndUserText.label: 'Parent Wt/Pc'
      ParentNetwt,
      @EndUserText.label: 'Weight Unit'
      ParentNetWtUnit,
      @EndUserText.label: 'Child Qty'
      Childqty,
      @EndUserText.label: 'Child Qty Unit'
      Bomitemqtyunit,
      @EndUserText.label: 'Child Net Weight'
      ChildNetwt,
      @EndUserText.label: 'Net Wt Unit'
      ChildWtUnit,
      @EndUserText.label: 'Total Weight'
      Total_Wt,
      @EndUserText.label: 'Type of Mould'
      typeofmould,
      @EndUserText.label: 'Qty/Box'
      qtyperbox,
      @EndUserText.label: 'Moulding Line Speed'
      Mouldlinespd,
      @EndUserText.label: 'Rate'
      Rate,
      @EndUserText.label: 'Fixed Cost'
      FixedCost,
      @EndUserText.label: 'Rate-2'
      ratefc2,
      @EndUserText.label: 'Fixed Cost-2'
      FixedCost2,
      @EndUserText.label: 'Cost per Kg FC 1'
      CostKgFC1,
      @EndUserText.label: 'Cost per Kg FC 2'
      CostKgFC2
}
