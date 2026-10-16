@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Contract Report Consumption View'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_SALESCONTRACTRPT
  provider contract transactional_query
  as projection on ZI_SALESCONTRACTRPT
{
      @EndUserText.label: 'Sales Contract No'
      @Search.defaultSearchElement: true
  key SalesContNo,
      @UI.hidden: true
  key SalesContractItem,
      @EndUserText.label: 'Sales Contract Date'
      SalesContDt,
      @EndUserText.label: 'Valid Form'
      Valid_From,
      @EndUserText.label: 'Valid To'
      Valid_To,
      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Creation Date'
      CreateDate,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Customer PO No'
      CustPONo,
      @EndUserText.label: 'Customer PO Date'
      CustPODt,
      @EndUserText.label: 'PO Item No'
      POItemNo,
      @EndUserText.label: 'Delivery Date'
      DelDate,
      @EndUserText.label: 'Customer Req Del Date'
      CustReqdDate,
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
      @EndUserText.label: 'Packing Instruction (No.)'
      packinstr,
      @EndUserText.label: 'Rejection Reason'
      Rej_Reason,
      @EndUserText.label: 'Std Wt'
      StdWt,
      @UI.hidden: true
      ItemWeightUnit,
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
      //@EndUserText.label: 'Unit Price-DC'
      //UnitPriceDC,
      //@EndUserText.label: 'Total Price-DC'
      //TotalPriceDC,
      //@EndUserText.label: 'Total Price-INR'
      //TotalPriceINR,
      //@EndUserText.label: 'Currency'
      //Currency,
      //@EndUserText.label: 'Doc Rate'
      //Doc_Rate,
      //@EndUserText.label: 'Balance Value -DC'
      //BalValDC,
      //@EndUserText.label: 'Balance Value -INR'
      //BalValINR,
      @EndUserText.label: 'Revision No'
      Revson_No,
      @EndUserText.label: 'Pay Term'
      PayTerm,
      @EndUserText.label: 'Delivery Term'
      DelTerm,
      @EndUserText.label: 'PO Entry Mail Recd Date'
      PO_Entry_Mail_Recd_Dt,
      @EndUserText.label: 'SO Transfer Mail Recd Date'
      SO_Transfer_Mail_Recd_Dt
      
}
