@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Realization Report'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_SAL_REA 
as select from ZCDS_SAL_REA_1_F5
{
    @EndUserText.label: 'Sales Order'
    key SalesOrder,
    @EndUserText.label: 'Sales Order Item'
    key SalesOrderItem,
    @EndUserText.label: 'Status'
    Status,
    @EndUserText.label: 'DocDate'
    CreationDate,
    @EndUserText.label: 'Our commitment date'
    CommittedDeliveryDate,
    @EndUserText.label: 'CardCode'
    SoldToParty,
    @EndUserText.label: 'Employee Name'
    salesperson,
    @EndUserText.label: 'NumAtCard'
    PurchaseOrderByCustomer,
    @EndUserText.label: 'ItemCode'
    Material,
    @EndUserText.label: 'Dscription'
    SalesOrderItemText,
    @EndUserText.label: 'OCRCODE2'
    ProfitCenterName,
    @EndUserText.label: 'MOC'
    moc,
    @EndUserText.label: 'Order Reason'
    SDDocumentReasonText,
    @EndUserText.label: 'Hold Status'
    soholdstat,
    @EndUserText.label: 'Order Quantity'
    OrderQuantity,
    @EndUserText.label: 'Delivered Qty'
    Sodelqty,
    @EndUserText.label: 'Short Close Qty'
    shortcloseqty,
    @EndUserText.label: 'Balance Qty'
    Balanceqty,
    @EndUserText.label: 'Final Order Qty'
    FinalOrderQty,
    @EndUserText.label: 'Currency'
    TransactionCurrency,
    @EndUserText.label: 'Forex Rate'
    PriceDetnExchangeRate,
    @EndUserText.label: 'Rate'
    rate,
    @EndUserText.label: 'Order Amount'
    OrderAmount,
    @EndUserText.label: 'UnitWt'
    Unitwt,
    @EndUserText.label: 'SWeight'
    SWeight,
    @EndUserText.label: 'Fumigation Charges'
    FumCha,
    @EndUserText.label: 'Container Freight'
    ConFrt,
    @EndUserText.label: 'Excello Expenses'
    ExcExp,
    @EndUserText.label: 'Port Charges'
    PortCha,
    @EndUserText.label: 'THC Charges'
    ThcCha,
    @EndUserText.label: 'Document Charges'
    DocCha,
    @EndUserText.label: 'Dry Max'
    cast( 0 as abap.dec( 23, 2 ) ) as Drymax,
    @EndUserText.label: 'Container Guard'
    cast( 0  as abap.dec( 23, 2 ) ) as Congua,
    @EndUserText.label: 'Radiation Checking'
    RadCha,
    @EndUserText.label: 'Inspection Charges'
    Inspcha,
    @EndUserText.label: 'Freight-USD in INR'
    YY1_FreightUSD_SDH,    
    @EndUserText.label: 'ECGC PREMIUM RATE'
    Epcgprerat,
    @EndUserText.label: 'Bank & BL Charges'
    cast( 0 as abap.dec( 23, 2 ) ) as BankBlcha,
    @EndUserText.label: 'Short Relisation Charges'
    ShoReaCha,
    @EndUserText.label: 'Credit Period Days'
    CashDiscount1Days,
    @EndUserText.label: 'TotStdCost'
    totstdcost,    
    @EndUserText.label: 'Total Selling Exp'
    TotSelExp,
    @EndUserText.label: 'Selling Exp per Kg'
    selExpKg,
    @EndUserText.label: 'TotStdCost/Kg'
    Totstdcostkg,
    @EndUserText.label: 'Order Value/Kg'
    Ordvalkg,
    @EndUserText.label: 'Std Realisation Per Kg'
    StdReakg,
    @EndUserText.label: 'Freight Received Amt'
    frtrecamt,
    @EndUserText.label: 'FixedCost'
    fixedcost,
    @EndUserText.label: 'Metal Cost taken as per Order Booking'
    metalprice,    
    @EndUserText.label: 'Net Realization'
    Netrea,
    @EndUserText.label: 'Sales Amt in Lac'
    salamtlc,
    @EndUserText.label: 'Variable Cost in Lac'
    varcostlc,
    @EndUserText.label: 'Selling Exp in lac'
    selexplc,    
    @EndUserText.label: 'Shipment_Type'
    IncotermsClassification,
    @EndUserText.label: 'Unit Price'
    unitprice,
    @EndUserText.label: 'BOM Status'
    Bomstatus
}
