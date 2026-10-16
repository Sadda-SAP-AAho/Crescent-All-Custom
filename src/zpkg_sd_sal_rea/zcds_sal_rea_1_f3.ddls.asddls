@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Realization Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_1_F3
  as select from ZCDS_SAL_REA_1_F2
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
      case when DistributionChannel = 'EX' 
           then division( ( OrderAmount * 6 * ( CashDiscount1Days + 15 ) ), 36500, 2 )
           else division( ( OrderAmount * 9 * ( CashDiscount1Days + 15 ) ), 36500, 2 ) end as CashDiscount1Days,
      totstdcost,
      cast( ( coalesce( cast( FumCha as abap.dec( 23, 2 ) ), 0 ) + coalesce( cast( ExcExp  as abap.dec( 23, 2 ) ), 0 ) +
        coalesce( cast( DocCha as abap.dec( 23, 2 ) ), 0 ) + coalesce( cast( ShoReaCha as abap.dec( 23, 2 ) ), 0 ) +
        coalesce( cast( ConFrt as abap.dec( 23, 2 ) ), 0 ) + coalesce( cast( PortCha as abap.dec( 23, 2 ) ), 0 ) +
        coalesce( cast( ThcCha as abap.dec( 23, 2 ) ), 0 ) + coalesce( cast( RadCha as abap.dec( 23, 2 ) ), 0 ) +
        coalesce( cast( Inspcha as abap.dec( 23, 2 ) ), 0 ) + coalesce( cast( Epcgprerat as abap.dec( 23, 2 ) ), 0 ) + 
        coalesce( cast( YY1_FreightUSD_SDH as abap.dec( 23, 2 ) ), 0 ) ) as abap.dec( 23, 2 ) ) as TotSelExp,

      cast( case when SWeight is not initial then division( OrderAmount, SWeight, 2 ) else 0 end as abap.dec( 23, 2) ) as Ordvalkg,
      
      division( OrderAmount, 100000, 2 ) as salamtlc,
      division( ( totstdcost * SWeight ), 100000, 2 ) as varcostlc,
      
      frtrecamt,
      fixedcost,
      metalprice,
      IncotermsClassification,
      unitprice,
      Bomstatus
}
