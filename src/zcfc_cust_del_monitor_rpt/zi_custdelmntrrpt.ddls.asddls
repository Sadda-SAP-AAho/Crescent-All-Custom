@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Delivery Monitoring Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_CUSTDELMNTRRPT
  as select distinct from ZI_SALESREGSHRT    as a
    left outer join       ZI_SOWISEBODETAILS as b on  a.SalesOrderNumber = b.SalesOrderNumber
                                                  and a.SalesOrderItem   = b.SalesOrderItem
    left outer join       I_SalesOrderItem   as c on  a.SalesOrderNumber = c.SalesOrder
                                                  and a.SalesOrderItem   = c.SalesOrderItem
    left outer join       ZI_DELDASHDATA     as d on a.OutboundDeliveryNo = d.OutboundDeliveryNo
    left outer join       I_SalesDocument    as e on a.SalesOrderNumber = e.SalesDocument

{
  key a.GstInvoice,
  key a.BillingDocumentItem,
  key a.SalesOrderItem,
  key a.CommercialInvNum,
  key a.LedgerName,
  key a.BP,
  key a.MatCode,
  key a.MatName,
  key a.ShpBill,
      a.GstInvDate,
      a.InvoiceType,
      a.CommInvDate,
      a.BPCode,
      a.Plant,
      a.ShipmentLocation,
      a.ProfitCenter,
      b.SalesContract,
      b.SalesContractDate,
      a.SalesOrderNumber,
      a.SoItemNo,
      a.SalesOrderDate,
      c.YY1_CustomerRequiredDe_SDI                                          as CustReqDate,
      a.CommittedDeliveryDate,
      a.OutboundDeliveryNo,
      a.PGI_No,
      a.PGI_Date,
      a.ItemDescription,
      a.UOM,
      a.Qty,
      a.unitWeight,
      a.HSNCODE,
      a.TransactionCurrency,
      a.PortOfLoading,
      a.FinalDestination,
      a.ContainerSize,
      a.ShippingLine,
      a.VesselName,
      a.BLNo,
      a.BLDate,
      a.DocumentSentDate,
      a.DocumentPresentDate,
      d.Etadt,
      d.Atadt,
      a.ShipBill,
      a.ShipBillDate,
      a.PortOfDischarge,
      a.Container,
      a.Material,
      a.WeightUnit,
      a.NetWeight,
      a.CustomerPo,
      a.CustomerPoDate,
      ( case when ( a.CustomerPoDate = '00000000'
                and b.SalesContractDate <> '00000000' )
             then b.SalesContractDate

             when ( a.CustomerPoDate = '00000000'
              and ( b.SalesContractDate = '00000000' or b.SalesContractDate is null )
              and a.SalesOrderDate <> '00000000' )
             then a.SalesOrderDate

             else a.CustomerPoDate
        end )                                                               as FinalSODt,

      ( case when b.YY1_POEntryMailRecdDat_SDH is initial
             then e.YY1_POEntryMailRecdDat_SDH

             else b.YY1_POEntryMailRecdDat_SDH end )                        as POEntryMailRecdDt,

      e.YY1_SOTransferMailRecd_SDH                                          as SOTrnsMailRcvDt,
      d.Contdisfact,
      d.Condockindt,
      (case when a.PGI_Date is initial then cast( '0' as abap.int4 )
            else cast( dats_days_between( a.PGI_Date,
                                        ( case when ( a.CustomerPoDate = '00000000'
                                                  and b.SalesContractDate <> '00000000' )
                                               then b.SalesContractDate

                                               when ( a.CustomerPoDate = '00000000'
                                                and ( b.SalesContractDate = '00000000' or b.SalesContractDate is null )
                                                and a.SalesOrderDate <> '00000000' )
                                               then a.SalesOrderDate

                                               else a.CustomerPoDate
                                          end ) ) as abap.int4 ) end )      as DelSODate,

      (case when ( a.BLDate is initial or a.PGI_Date is initial ) then cast( '0' as abap.int4 )
            else cast( dats_days_between( a.BLDate,
                                          a.PGI_Date ) as abap.int4 ) end ) as BLDelDate,

      (case when ( d.Atadt is initial or a.BLDate is initial ) then cast( '0' as abap.int4 )
            else cast( dats_days_between( d.Atadt,
                                          a.BLDate ) as abap.int4 ) end )   as ATABLDate,

      (case when d.Atadt is initial then cast( '0' as abap.int4 )
            else cast( dats_days_between( d.Atadt,
                                        ( case when ( a.CustomerPoDate = '00000000'
                                                  and b.SalesContractDate <> '00000000' )
                                               then b.SalesContractDate

                                               when ( a.CustomerPoDate = '00000000'
                                                and ( b.SalesContractDate = '00000000' or b.SalesContractDate is null )
                                                and a.SalesOrderDate <> '00000000' )
                                               then a.SalesOrderDate

                                               else a.CustomerPoDate
                                          end ) ) as abap.int4 ) end )      as ATASODate,
      a.wtunit,
      a.eachgrowt,
      a.salesperson
}
