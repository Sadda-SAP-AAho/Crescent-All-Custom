@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Contract-Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SALESCONTRACTRPT
  as select distinct from ZI_SALESCONTHEAD as a
    inner join            ZI_SALESCONTITM  as b on a.Sales_Cont_No = b.Sales_Cont_No
{
  key a.Sales_Cont_No                             as SalesContNo,
  key b.SalesContractItem,
      a.Sales_Cont_Dt                             as SalesContDt,
      a.Valid_From,
      a.Valid_To,
      a.CreatedBy,
      a.CreateDate,
      b.Plant,
      a.Cust_PO_No                                as CustPONo,
      a.Cust_PO_Dt                                as CustPODt,
      b.POItemNo                                  as POItemNo,
      b.Del_Date                                  as DelDate,
      b.YY1_CustomerRequiredDe_SDI                as CustReqdDate,
      a.Cust_Code                                 as CustCode,
      a.Sales_Person                              as SalesPerson,
      a.Port_of_Discharge                         as PortofDischarge,
      b.ProfitCenter,
      b.Mat_Code                                  as MatCode,
      b.Mat_Name                                  as MatName,
      b.moc,
      b.HSN,
      b.BOM_Item,
      b.ptnapp,
      b.pilotprdapp,
      b.MaterialByCustomer                        as MatbyCust,
      b.materialpaintinfo                         as Paint_Info,
      b.packinstr,
      b.Rej_Reason,
      b.ItemWeightUnit,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      b.Std_Wt                                    as StdWt,
      b.TargetQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'TargetQuantityUnit'
      b.Contr_Qty                                 as ContractQty,
      b.UnitOfMeasure_E                           as UoM,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      b.Contr_Wt                                  as Contr_Wt,
      @Semantics.quantity.unitOfMeasure: 'TargetQuantityUnit'
      cast ( ( case when b.Rej_Reason is null
             then b.Bal_Qty
             else 0.00 end )  as abap.dec(13,3) ) as Bal_Qty,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      cast ( ( case when b.Rej_Reason is null
             then b.Bal_Wt
             else 0.00 end )  as abap.dec(13,3) ) as Bal_Wt,
      //cast( b.Unit_Price_DC as abap.dec( 13, 3) )   as UnitPriceDC,
      //cast( b.Total_Price_DC as abap.dec( 13, 3) )  as TotalPriceDC,
      //cast( b.Total_Price_INR as abap.dec( 13, 3) ) as TotalPriceINR,
      //b.Currency,
      //b.Doc_Rate,
      //cast( b.Bal_Val_DC as abap.dec( 13, 3) )      as BalValDC,
      //cast( b.Bal_Val_INR as abap.dec( 13, 3) )     as BalValINR,
      b.Revson_No,
      a.PayTerm                                   as PayTerm,
      a.Del_Term                                  as DelTerm,
      a.PO_Entry_Mail_Recd_Dt,
      a.SO_Transfer_Mail_Recd_Dt

}

where
  a.Valid_To >= $session.system_date
