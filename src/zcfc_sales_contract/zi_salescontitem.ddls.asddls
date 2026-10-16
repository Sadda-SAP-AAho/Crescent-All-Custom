@AbapCatalog.sqlViewName: 'ZSALESCONTLINE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Sales Contract Line'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SALESCONTLINE
  as select distinct from I_SalesContractItem            as a
    inner join            I_SalesContract                as b on a.SalesContract = b.SalesContract
    left outer join       I_Product                      as c on a.Material = c.Product
    inner join            I_UnitOfMeasure                as d on a.TargetQuantityUnit = d.UnitOfMeasure
    inner join            ZI_BALCONTRQTY                 as e on  a.SalesContract     = e.Sales_Cont_No
                                                              and a.SalesContractItem = e.SalesContractItem
                                                              and a.Material          = e.Mat_Code
    left outer join       I_ProductPlantBasic            as f on  a.Material = f.Product
                                                              and a.Plant    = f.Plant
    inner join            I_UnitOfMeasure                as g on a.TargetQuantityUnit = g.UnitOfMeasure
    left outer join       I_ProfitCenterText             as h on a.ProfitCenter = h.ProfitCenter
    left outer join       zdt_pp_matinffld               as i on a.Material = i.product
    left outer join       I_ProductSalesDelivery         as j on  j.Product                 = c.Product
                                                              and j.ProductSalesOrg         = b.SalesOrganization
                                                              and j.ProductDistributionChnl = b.DistributionChannel
    left outer join       I_AdditionalMaterialGroup1Text as k on j.FirstSalesSpecProductGroup = k.AdditionalMaterialGroup1

    left outer join       ZTBL_FCTN_BOM_ITEM             as l on  a.Material = l.material
                                                              and a.Plant    = l.plant
    left outer join       zdt_paintinfo                  as m on  a.SalesContract = m.salescontract
                                                              and a.Material      = m.salescontractitem
    left outer join       I_SalesDocumentRjcnReasonText  as n on  a.SalesDocumentRjcnReason = n.SalesDocumentRjcnReason
                                                              and n.Language                = 'E'
    left outer join       I_SalesDocumentItem            as o on  a.SalesContract     = o.SalesDocument
                                                              and a.SalesContractItem = o.SalesDocumentItem


{
  key a.SalesContract                                                                         as Sales_Cont_No,
      a.Plant,
      a.BillingDocumentDate                                                                   as Del_Date,
      h.ProfitCenterName                                                                      as ProfitCenter,
      a.SalesContractItem,
      a.Material                                                                              as Mat_Code,
      a.SalesContractItemText                                                                 as Mat_Name,
      o.UnderlyingPurchaseOrderItem                                                           as POItemNo,
      i.moc,
      ( case when ( a.Material = l.material and a.Plant = l.plant) then 'YES' else 'NO' end ) as BOM_Item,
      a.MaterialByCustomer,
      cast( i.paintinfo as abap.char( 254 ) )                                                 as materialpaintinfo,
      k.AdditionalMaterialGroup1Name                                                          as Revson_No,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      c.NetWeight                                                                             as Std_Wt,
      a.ItemWeightUnit,
      f.ConsumptionTaxCtrlCode                                                                as HSN,
      i.ptnapp,
      i.pilotprdapp,
      n.SalesDocumentRjcnReasonName                                                           as Rej_Reason,
      a.TargetQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'TargetQuantityUnit'
      a.TargetQuantity                                                                        as Contr_Qty,
      e.UnitOfMeasure_E,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ( a.TargetQuantity * c.NetWeight )                                                      as Contr_Wt,
      a.TransactionCurrency                                                                   as Currency,
      a.PriceDetnExchangeRate                                                                 as Doc_Rate,
      a.NetPriceAmount                                                                        as Unit_Price_DC,
      ( a.TargetQuantity * a.NetPriceAmount )                                                 as Total_Price_DC,
      ( a.TargetQuantity * a.NetPriceAmount * a.PriceDetnExchangeRate )                       as Total_Price_INR,
      @Semantics.quantity.unitOfMeasure: 'TargetQuantityUnit'
      e.Bal_Qty,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      e.Bal_Wt,
      e.Bal_Val_DC,
      e.Bal_Val_INR,
      o.YY1_CustomerRequiredDe_SDI





}

where
  a.SalesDocumentRjcnReason is initial
