@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register Short(Price)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }
define root view entity ZI_SALESREGSHRTPRCE
  as select distinct from ZCDS_SALES_TMPFINAL as a
    left outer join       ZI_PGIDETAILS       as b on  a.OutboundDeliveryNo  = b.DeliveryDocument
                                                   and a.BillingDocumentItem = b.BillingDocumentItem
    left outer join       I_SalesOrderItem    as c on  a.SalesOrderNumber = c.SalesOrder
                                                   and a.SalesOrderItem   = c.SalesOrderItem
{
  key a.GstInvoice,
  key a.BillingDocumentItem,
  key a.SalesOrderItem,
  key a.CommercialInvNum,
  key a.LedgerName,
  key a.BPCode                                                    as BP,
  key a.Material                                                  as MatCode,
  key a.ItemDescription                                           as MatName,
  key a.ShipBill                                                  as ShpBill,
      a.SalesOrg,
      a.GstInvDate,
      a.InvoiceType,
      a.CommInvDate,
      a.BPCode,
      ( case when a.ShipmentLocation = 'SALAP' then '1100'
             when a.ShipmentLocation = 'KULGACHIA' then '1200'
             when a.ShipmentLocation = 'BAGNAN' then '1300'
             when a.ShipmentLocation = 'BARODA' then '1400' end ) as Plant,
      a.ShipmentLocation,
      a.ProfitCenter,
      a.SalesOrderNumber,
      a.SalesOrderItem                                            as SoItemNo,
      a.SalesOrderDate,
      c.CommittedDeliveryDate,
      a.SaleNoteRef,
      a.OutboundDeliveryNo,
      b.PGI_No,
      b.PGI_Date,
      a.ContaionerName,
      a.SalesEmpName,
      a.ItemDescription,
      a.UOM,
      a.Qty,
      a.unitWeight,
      a.eachgrowt                                                 as GrossWeight,
      a.HSNCODE,
      a.TransactionCurrency,
      a.DISC,
      a.ExportFreight,
      a.PayTerms,
      a.StuffingDate,
      a.PortOfLoading,
      a.FinalDestination,
      a.ContainerSize,
      a.ShippingLine,
      a.ShippingType,
      a.VesselName,
      a.BLNo,
      a.BLDate,
      a.DocumentSentDate,
      a.DocumentPresentDate,
      a.AWBNo,
      a.ISFSentDate,
      a.LCNo,
      a.LCDate,
      a.LCIssuBank,
      a.ShipBill,
      a.ShipBillDate,
      a.EXInsurance,
      a.PortOfDischarge,
      a.Container,
      a.Material,
      a.WeightUnit,
      ( case when ( a.InvoiceType = 'DN'
             or a.InvoiceType = 'CN' )
             then ( a.NetWeight * (-1))

             else a.NetWeight end )                               as NetWeight,
      a.CustomerPo,
      a.CustomerPoDate,
      a.wtunit,
      a.eachgrowt,
      a.ValueInLC,
      a.CountOfDest,
      a.DocumentReferenceID,
      a.CommInvRef,
      a.salesperson

}
