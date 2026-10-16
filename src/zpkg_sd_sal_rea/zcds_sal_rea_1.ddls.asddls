@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Realization Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_1
  as select from    I_SalesOrderItem       as a
    inner join      I_SalesOrder           as b   on b.SalesOrder = a.SalesOrder
    left outer join I_ProfitCenterText     as c   on  c.ProfitCenter = a.ProfitCenter
                                                  and c.Language     = 'E'
    left outer join zdt_pp_matinffld       as d   on d.product = a.Material
    left outer join ztmg_salesgrp          as e   on  e.salesgroup            = b.SalesGroup
                                                  and e.configdeprecationcode is initial
    left outer join ZCDS_SAL_REA_2         as f   on  f.ReferenceSDDocument     = a.SalesOrder
                                                  and f.ReferenceSDDocumentItem = a.SalesOrderItem
    left outer join ZCDS_SAL_REA_3         as g   on g.hedmaterial = a.Material
    left outer join zdt_mould              as h   on h.mould = d.typeofmould
    left outer join ZCDS_SAL_REA_4         as i   on  i.SalesDocument     = a.SalesOrder
                                                  and i.SalesDocumentItem = a.SalesOrderItem
    left outer join ZCDS_SAL_REA_4         as m   on  m.SalesDocument     = a.ReferenceSDDocument
                                                  and m.SalesDocumentItem = a.ReferenceSDDocumentItem
  //    left outer join I_ProductValuationBasic as j   on  j.Product       = a.Material
  //                                                   and j.ValuationArea = a.Plant
  //                                                   and j.ValuationType is initial
    left outer join ZCDS_SAL_REA_11        as j   on  j.SalesOrder     = a.SalesOrder
                                                  and j.SalesOrderItem = a.SalesOrderItem
    left outer join ZCDS_SAL_REA_6         as k   on k.PaymentTerms = b.CustomerPaymentTerms
    left outer join ZCDS_SAL_REA_7         as l1  on  l1.Custcode    =  b.SoldToParty
                                                  and l1.Expcode     =  'ZFUC'
                                                  and b.CreationDate >= l1.Datefrom
                                                  and b.CreationDate <= l1.Dateto
    left outer join ZCDS_SAL_REA_7         as l2  on  l2.Custcode    =  b.SoldToParty
                                                  and l2.Expcode     =  'ZEXC'
                                                  and b.CreationDate >= l2.Datefrom
                                                  and b.CreationDate <= l2.Dateto
    left outer join ZCDS_SAL_REA_7         as l3  on  l3.Custcode    =  b.SoldToParty
                                                  and l3.Expcode     =  'ZDUC'
                                                  and b.CreationDate >= l3.Datefrom
                                                  and b.CreationDate <= l3.Dateto
    left outer join ZCDS_SAL_REA_7         as l4  on  l4.Custcode    =  b.SoldToParty
                                                  and l4.Expcode     =  'ZBSR'
                                                  and b.CreationDate >= l4.Datefrom
                                                  and b.CreationDate <= l4.Dateto
    left outer join ZCDS_SAL_REA_7         as l5  on  l5.Custcode    =  b.SoldToParty
                                                  and l5.Expcode     =  'ZCNF'
                                                  and b.CreationDate >= l5.Datefrom
                                                  and b.CreationDate <= l5.Dateto
    left outer join ZCDS_SAL_REA_7         as l6  on  l6.Custcode    =  b.SoldToParty
                                                  and l6.Expcode     =  'ZPRC'
                                                  and b.CreationDate >= l6.Datefrom
                                                  and b.CreationDate <= l6.Dateto
    left outer join ZCDS_SAL_REA_7         as l7  on  l7.Custcode    =  b.SoldToParty
                                                  and l7.Expcode     =  'ZTHC'
                                                  and b.CreationDate >= l7.Datefrom
                                                  and b.CreationDate <= l7.Dateto
    left outer join ZCDS_SAL_REA_7         as l8  on  l8.Custcode    =  b.SoldToParty
                                                  and l8.Expcode     =  'ZTHC'
                                                  and b.CreationDate >= l8.Datefrom
                                                  and b.CreationDate <= l8.Dateto
    left outer join ZCDS_SAL_REA_7         as l9  on  l9.Custcode    =  b.SoldToParty
                                                  and l9.Expcode     =  'ZTHC'
                                                  and b.CreationDate >= l9.Datefrom
                                                  and b.CreationDate <= l9.Dateto
    left outer join ZCDS_SAL_REA_7         as l10 on  l10.Custcode   =  b.SoldToParty
                                                  and l10.Expcode    =  'ZRDC'
                                                  and b.CreationDate >= l10.Datefrom
                                                  and b.CreationDate <= l10.Dateto
    left outer join ZCDS_SAL_REA_9         as n   on  n.SalesOrder     = a.SalesOrder
                                                  and n.SalesOrderItem = a.SalesOrderItem
    left outer join ZCDS_SAL_REA_10        as o   on o.SalesOrder = a.SalesOrder

    left outer join I_SDDocumentReasonText as z2  on  z2.SDDocumentReason = b.SDDocumentReason
                                                  and z2.Language         = 'E'
    left outer join ZCDS_SCHEDULINE1       as p   on  p.SalesOrder     = a.SalesOrder
                                                  and p.SalesOrderItem = a.SalesOrderItem
   
{
  key a.SalesOrder,
  key a.SalesOrderItem,
      case when b.OverallSDProcessStatus = 'C   ' then cast( 'CLOSED' as abap.char( 6 ) )
           else cast( 'OPEN' as abap.char( 6 ) ) end                                                                            as Status,
      b.CreationDate,
      ( case when a.YY1_OTIFDate_SDI is initial then a.CommittedDeliveryDate
              else a.YY1_OTIFDate_SDI end )                                                                                     as CommittedDeliveryDate,
      b.SoldToParty,
      e.salesperson,
      b.PurchaseOrderByCustomer,
      a.Material,
      a.SalesOrderItemText,
      c.ProfitCenterName,
      d.moc,
      z2.SDDocumentReasonText,
      p.soholdstat,
      cast( a.OrderQuantity as abap.dec( 13, 3 ) )                                                                              as OrderQuantity,
      cast( f.sodelqty as abap.dec( 13, 3 ) )                                                                                   as Sodelqty,
      cast( case when a.SalesDocumentRjcnReason is not initial
           then ( coalesce( cast( a.OrderQuantity as abap.dec( 13, 3 ) ), 0 ) - coalesce( cast( f.sodelqty as abap.dec( 13, 3 ) ), 0  ) )
           else 0 end as abap.dec( 13, 3 ) )                                                                                    as shortcloseqty,
      ( coalesce( cast( a.OrderQuantity as abap.dec( 13, 3 ) ), 0 ) - coalesce( cast( f.sodelqty as abap.dec( 13, 3 ) ), 0  ) ) as Balanceqty,
      a.TransactionCurrency,
      b.PriceDetnExchangeRate,
      i.rate,
      i.Baseprice                                                                                                               as price,
      i.matprice                                                                                                                as matprice,
      case when a.OrderQuantity is not initial
           then division( i.disc, cast( a.OrderQuantity as abap.dec( 13, 3 ) ), 2 )
           else 0 end                                                                                                           as disc,

      l1.Rate                                                                                                                   as Fumcha,
      l5.Rate                                                                                                                   as ConFrt,
      l2.Rate                                                                                                                   as ExcExp,
      l6.Rate                                                                                                                   as PortCha,
      l7.Rate                                                                                                                   as ThcCha,
      l3.Rate                                                                                                                   as DocCha,
      l10.Rate                                                                                                                  as RadCha,
      l8.Rate                                                                                                                   as Inspcha,
      l9.Rate                                                                                                                   as Epcgprerat,
      l4.Rate                                                                                                                   as ShoReaCha,
      case when o.ItemNetWeight is not initial
      then division( cast( ( cast( (b.YY1_FreightUSD_SDH * n.ExchangeRate ) as abap.dec( 15, 2 ) ) * a.ItemNetWeight ) as abap.dec( 23, 2 ) ), o.ItemNetWeight , 2 )
      else cast( 0 as abap.dec( 23, 2 ) ) end                                                                                   as YY1_FreightUSD_SDH,
      k.CashDiscount1Days,
      //      case j.InventoryValuationProcedure when 'S' then cast( j.StandardPrice as abap.dec( 23, 2 ) )
      //                                         when 'V' then cast( j.MovingAveragePrice as abap.dec( 23, 2 ) )
      //                                         else cast( 0 as abap.dec( 23, 2 ) )  end
      j.TotalAmountInCoCodeCrcy                                                                                                 as totstdcost,
      case when a.OrderQuantity is not initial
           then cast( division( cast( a.ItemNetWeight as abap.dec( 13, 3 ) ), cast( a.OrderQuantity as abap.dec( 13, 3 ) ), 3 ) as abap.dec( 13, 3 ) )
           else cast( 0 as abap.dec( 13, 3 ) ) end                                                                              as Unitwt,
      //      case when a.OrderQuantity is not initial
      //           then cast( division( cast( ( i.frtprice * b.PriceDetnExchangeRate ) as abap.dec( 13, 3 ) ), cast( a.OrderQuantity as abap.dec( 13, 3 ) ), 3 ) as abap.dec( 13, 3 ) )
      //           else cast( 0 as abap.dec( 13, 3 ) ) end
      cast( ( i.frtprice * b.PriceDetnExchangeRate ) as abap.dec( 13, 3 ) )                                                     as frtrecamt,
      h.rate1                                                                                                                   as fixedcost,
      case when m.metalprice is not initial then m.metalprice else i.metalprice end                                             as metalprice,
      b.IncotermsClassification,
      ( i.Baseprice + i.matprice )                                                                                              as unitprice,
      case when g.hedmaterial is not initial then cast( 'Y' as abap.char( 1 ) )
           else cast( 'N' as abap.char( 1 ) ) end                                                                               as Bomstatus,
      b.DistributionChannel

}
