@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Realization Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_1_F4 
as select from ZCDS_SAL_REA_1_F3
{
    key SalesOrder,
    key SalesOrderItem,
    Status,
    CreationDate,
    CommittedDeliveryDate,
    SoldToParty,
    salesperson,
    PurchaseOrderByCustomer,
    Material,
    SalesOrderItemText,
    ProfitCenterName,
    moc,
    SDDocumentReasonText,
    soholdstat,
    OrderQuantity,
    Sodelqty,
    shortcloseqty,
    Balanceqty,
    FinalOrderQty,
    TransactionCurrency,
    PriceDetnExchangeRate,
    rate,
    OrderAmount,
    Unitwt,
    SWeight,
    FumCha,
    ConFrt,
    ExcExp,
    PortCha,
    ThcCha,
    DocCha,
    RadCha,
    Inspcha,
    YY1_FreightUSD_SDH,
    Epcgprerat,
    ShoReaCha,
    CashDiscount1Days,
    totstdcost,
    ( coalesce( cast( TotSelExp as abap.dec( 23, 2 ) ), 0 ) + coalesce( cast( CashDiscount1Days as abap.dec( 23, 2 ) ), 0 )  ) as TotSelExp,
    case when SWeight is not initial then division( ( coalesce( cast( TotSelExp as abap.dec( 23, 2 ) ), 0 ) + coalesce( cast( CashDiscount1Days as abap.dec( 23, 2 ) ), 0 )  ), SWeight, 2 ) else 0 end as selExpKg,
    ( case when SWeight is not initial then division( ( coalesce( cast( TotSelExp as abap.dec( 23, 2 ) ), 0 ) + coalesce( cast( CashDiscount1Days as abap.dec( 23, 2 ) ), 0 )  ), SWeight, 2 ) else 0 end ) 
    + ( case when SWeight is not initial then division( totstdcost, SWeight, 2 ) else 0 end ) as Totstdcostkg,
    Ordvalkg,    
    ( coalesce( Ordvalkg, 0 ) - coalesce( ( ( case when SWeight is not initial then division( ( coalesce( cast( TotSelExp as abap.dec( 23, 2 ) ), 0 ) + coalesce( cast( CashDiscount1Days as abap.dec( 23, 2 ) ), 0 )  ), SWeight, 2 ) else 0 end ) 
    + totstdcost ), 0 ) ) as StdReakg,
    frtrecamt,
    fixedcost,
    metalprice,
    salamtlc,
    varcostlc,
    division( ( coalesce( cast( TotSelExp as abap.dec( 23, 2 ) ), 0 ) + coalesce( cast( CashDiscount1Days as abap.dec( 23, 2 ) ), 0 )  ), 100000, 2 ) as selexplc,
    IncotermsClassification,
    unitprice,
    Bomstatus
}
