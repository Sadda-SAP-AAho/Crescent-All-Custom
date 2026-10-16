@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Realization Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_1_F2 
as select from ZCDS_SAL_REA_1_F1
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
    ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) ) as FinalOrderQty,
    TransactionCurrency,
    PriceDetnExchangeRate,
    rate,
    cast( ( ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) )
     * cast( ( unitprc * PriceDetnExchangeRate ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) ) as OrderAmount,
    Unitwt,
    cast( ( ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) ) 
     * Unitwt ) as abap.dec( 13, 3 ) ) as SWeight,
    cast( ( ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) ) 
     * cast( ( Unitwt * Fumcha ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) ) as FumCha,
    cast( ( ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) ) 
     * cast( ( Unitwt * ConFrt ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) ) as ConFrt,  
    cast( ( ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) ) 
     * cast( ( Unitwt * ExcExp ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) ) as ExcExp, 
    cast( ( ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) ) 
     * cast( ( Unitwt * PortCha ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) ) as PortCha,
    cast( ( ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) ) 
     * cast( ( Unitwt * ThcCha ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) ) as ThcCha,   
    cast( ( ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) ) 
     * cast( ( Unitwt * DocCha ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) ) as DocCha,
    cast( ( ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) ) 
     * cast( ( Unitwt * RadCha ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) ) as RadCha,
    cast( ( ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) ) 
     * cast( ( Unitwt * Inspcha ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) ) as Inspcha, 
    cast( ( ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) ) 
     * cast( ( Unitwt * Epcgprerat ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) ) as Epcgprerat,   
    cast( ( ( coalesce( cast( Sodelqty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) ) 
     * cast( ( Unitwt * ShoReaCha ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) ) as ShoReaCha,     
    YY1_FreightUSD_SDH, 
    CashDiscount1Days,
    totstdcost,    
    frtrecamt,
    fixedcost,
    metalprice,
    IncotermsClassification,
    unitprice,
    Bomstatus,
    DistributionChannel
}
