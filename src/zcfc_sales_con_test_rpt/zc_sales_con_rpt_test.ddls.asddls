@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Contract Report Consumption View Test'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_SALES_CON_RPT_TEST
  provider contract transactional_query
  as projection on ZI_SALES_CON_RPT_TEST
{
      @EndUserText.label: 'Sales Contract No'
      @Search.defaultSearchElement: true
  key SalesContNo,
      @UI.hidden: true
  key SalesContractItem,
      @EndUserText.label: 'Sales Contract Date'
      SalesContDt,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Customer PO No'
      CustPONo,
      @EndUserText.label: 'Customer PO Date'
      CustPODt,
      @EndUserText.label: 'Delivery Date'
      DelDate,
      @EndUserText.label: 'Customer Code'
      CustCode,
      @EndUserText.label: 'Sales Employee'
      SalesPerson,
      @EndUserText.label: 'Port of Discharge'
      PortofDischarge,
      @EndUserText.label: 'Profit Center'
      ProfitCenter,
      @EndUserText.label: 'Item Code'
      MatCode,
      @EndUserText.label: 'Description'
      MatName,
      @EndUserText.label: 'MOC'
      moc,
      @EndUserText.label: 'HSN'
      HSN,
      @EndUserText.label: 'BOM Item'
      BOM_Item,
      @EndUserText.label: 'Pattern Approved'
      ptnapp,
      @EndUserText.label: 'Pilot Prodn Approved'
      pilotprdapp,
      @EndUserText.label: 'Customer Description'
      MatbyCust,
      @EndUserText.label: 'Paint Information'
      Paint_Info,
      @EndUserText.label: 'Rejection Reason'
      Rej_Reason,
      @UI.hidden: true
      ItemWeightUnit,
      @EndUserText.label: 'Std Wt'
      StdWt,
      @UI.hidden: true
      TargetQuantityUnit,
      @EndUserText.label: 'Sales Contact Qty'
      ContractQty,
      @UI.hidden: true
      UoM,
      @EndUserText.label: 'Sales Contact Wt'
      Contr_Wt,
      @EndUserText.label: 'Balance Qty '
      Bal_Qty,
      @EndUserText.label: 'Balance Wt'
      Bal_Wt,
      @EndUserText.label: 'Revision No'
      Revson_No,
      @EndUserText.label: 'Pay Term'
      PayTerm,
      @EndUserText.label: 'Delivery Term'
      DelTerm
}
