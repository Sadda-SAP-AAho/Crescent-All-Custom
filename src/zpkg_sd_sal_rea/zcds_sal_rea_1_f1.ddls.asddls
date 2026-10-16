@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Realization Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_1_F1 
as select from ZCDS_SAL_REA_1
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
    ( coalesce( cast( Balanceqty as abap.dec( 13, 3 ) ), 0 ) - coalesce( cast( shortcloseqty as abap.dec( 13, 3 ) ), 0 ) ) as Balanceqty,
    TransactionCurrency,
    PriceDetnExchangeRate,  
    rate,
    ( coalesce( price, 0 ) + coalesce( matprice, 0 ) + coalesce( disc, 0 ) ) as unitprc,
    Fumcha,
    ConFrt,
    ExcExp,
    PortCha,
    ThcCha,
    DocCha,
    RadCha,
    Inspcha,
    Epcgprerat,
    ShoReaCha,
    YY1_FreightUSD_SDH,
    CashDiscount1Days,
    totstdcost,
    Unitwt,
    frtrecamt,
    fixedcost,
    metalprice,
    IncotermsClassification,
    unitprice,
    Bomstatus,
    DistributionChannel
}
