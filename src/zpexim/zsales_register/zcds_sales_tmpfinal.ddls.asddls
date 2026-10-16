@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Interface View for Sales Register'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZCDS_SALES_TMPFINAL

  as select distinct from ZCDS_SALES_TMP3

{
  key GstInvoice                                                                                 as GstInvoice,
  key cast( BillingDocumentItem as abap.char(6))                                                 as BillingDocumentItem,
  key SalesOrderItem,
  key cast(CommercialInvNum as abap.char(16))                                                    as CommercialInvNum,
  key LedgerName,

      GSTInNo,
      PANNo, //Added by SP on 16.06.25
      SalesOrg,
      GstInvDate,
      cast(ExchangeRate as abap.dec(10,2))                                                       as ExchangeRate,
      InvoiceType,
      CommInvDate,
      BPCode,
      ShipmentLocation,
      SalesOrderNumber,
      OutboundDeliveryNo,
      SalesOrderDate,
      SaleNoteRef,
      ContaionerName,
      BPName,
      StateName,
      SalesEmpName,
      Currency,
      cast( ItemDescription as abap.char(128) )                                                  as ItemDescription,
      UOM,
      //        @Semantics.quantity.unitOfMeasure: 'Uom'
      cast(Qty as abap.dec(23,2))                                                                as Qty,
      //        @Semantics.quantity.unitOfMeasure: 'Uom'
      cast(unitWeight as abap.dec(23,2))                                                         as unitWeight,
      //        @Semantics.quantity.unitOfMeasure: 'Uom'
      cast(GrossWeight  as abap.dec(23,2))                                                       as GrossWeight,
      //      cast( ( cast( netweight * Qty as abap.dec(10,2)) + eachgrowt )  as abap.dec(10,2))         as GrossWeight,
      HSNCODE,
      TransactionCurrency,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(ValueInDC as abap.dec(23,2))                                                          as ValueInDC,
      cast(cast(ValueInDC as abap.fltp) * cast(ExchangeRate as abap.fltp) as abap.dec(23,2))     as ValueInLC,

      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(ValueInDcComm as abap.dec(23,2))                                                      as ValueInDcComm,
      cast(cast(ValueInDcComm as abap.fltp) * cast(ExchangeRate as abap.fltp) as abap.dec(23,2)) as ValueInLCom,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      DISC,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      ExportFreight,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast((IGSTAmount * ExchangeRate) as abap.dec(23,2))                                        as IGSTAmount,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast((CGSTAmount * ExchangeRate) as abap.dec(23,2))                                        as CGSTAmount,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast((SGSTAmount * ExchangeRate) as abap.dec(23,2))                                        as SGSTAmount,
      // Added by SP on 16.06.25
      cast((TCSAmount * ExchangeRate) as abap.dec(23,2))                                         as TCSAmount,
      // End of Added by SP on 16.06.25
      PayTerms,
      StuffingDate,
      PortOfLoading,
      FinalDestination,
      ContainerSize,
      ShippingLine,
      ShippingType,
      VesselName,
      BLNo,
      BLDate,
      DocumentSentDate,
      DocumentPresentDate,
      AWBNo,
      ISFSentDate,
      EBRCNo,
      EBRCDate,
      ProfitCenter,
      LCNo,
      LCDate,
      LCIssuBank,
      IRNNo,
      EWAYBILLNo,
      ShipBill,
      ShipBillDate,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      get_numeric_value(DisInDC)                                                                 as DisInDC,
      cast(cast(DisInDC as abap.fltp) * cast(ExchangeRate as abap.fltp) as abap.dec(10,2))       as DisInLC,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      EXInsurance,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      get_numeric_value(FInsuranceINDc)                                                          as FInsuranceINDc,
      PortOfDischarge,
      Container,

      Material,
      MaterialGrp,
      WeightUnit,

      // Old Logic //
      //cast(netweight1 * Qty1 as abap.dec(15,3))                                                  as NetWeight,

      // New Logic //
      cast(TransNetWt as abap.dec(15,3))                                                         as NetWeight,

      CustomerPo,
      CustomerPoDate,
      CustomerPOLineNo,
      BillingDocDate,
      wtunit,

      @Semantics.quantity.unitOfMeasure: 'wtunit'
      cast(eachgrowt as abap.dec(13,3))                                                          as eachgrowt,

      CountOfDest,
      GLAccount,
      GLAccountName,
      DocumentReferenceID,
      CommInvRef,
      salesperson,
      Etadt,
      AccountingDocument


}

union

select from ZV_FIREGISTERVF as a

{
  key ''                                                                   as GstInvoice,
  key cast( AccountingDocumentItem as abap.char(6))                        as BillingDocumentItem,
  key '000000'                                                             as SalesOrderItem,
  key a.CommercialInvoiceNo                                                as CommercialInvNum,
  key a.GSTInvoiceNo                                                       as LedgerName,

      a.GSTInNo,
      a.PANNo, //Added by SP on 16.06.25
      ''                                                                   as SalesOrg,
      a.PostingDate                                                        as GstInvDate,
      cast(a.AbsoluteExchangeRate as abap.dec(9,5))                        as ExchangeRate,
      case when AccountingDocumentType = 'DG' then 'CN' else 'Service' end as InvoiceType,
      a.PostingDate                                                        as CommInvDate,
      a.Customer                                                           as BPCode,
      ''                                                                   as ShipmentLocation,
      ''                                                                   as SalesOrderNumber,
      ''                                                                   as OutboundDeliveryNo,
      ''                                                                   as SalesOrderDate,
      ''                                                                   as SaleNoteRef,
      ''                                                                   as ContaionerName,
      a.BPName                                                             as BPName,
      a.StateName                                                          as StateName,
      ''                                                                   as SalesEmpName,
      a.TransactionCurrency                                                as Currency,
      a.DocumentItemText                                                   as ItemDescription,
      cast('' as abap.unit(3))                                             as UOM,
      //        @Semantics.quantity.unitOfMeasure: 'Uom'
      cast(0 as abap.dec(23,2))                                            as Qty,
      //        @Semantics.quantity.unitOfMeasure: 'Uom'
      cast(0 as abap.dec(23,2))                                            as unitWeight,
      //        @Semantics.quantity.unitOfMeasure: 'Uom'
      cast(0  as abap.dec(23,2))                                           as GrossWeight,
      //      cast( ( cast( netweight * Qty as abap.dec(10,2)) + eachgrowt )  as abap.dec(10,2))         as GrossWeight,
      a.IN_HSNOrSACCode                                                    as HSNCODE,
      a.TransactionCurrency,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(a.AmountinDC as abap.dec(23,2))                                 as ValueInDC,
      cast(a.AmountinLC as abap.dec(23,2))                                 as ValueInLC,

      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(a.AmountinDC as abap.dec(23,2))                                 as ValueInDcComm,
      cast(a.AmountinLC as abap.dec(23,2))                                 as ValueInLCom,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      0                                                                    as DISC,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      0                                                                    as ExportFreight,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(a.IGST as abap.dec(23,2))                                       as IGSTAmount,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(a.CGST as abap.dec(23,2))                                       as CGSTAmount,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(a.SGST as abap.dec(23,2))                                       as SGSTAmount,
      cast(0 as abap.dec(23,2))                                            as TCSAmount,
      a.PaymentTerms                                                       as PayTerms,
      ''                                                                   as StuffingDate,
      ''                                                                   as PortOfLoading,
      ''                                                                   as FinalDestination,
      ''                                                                   as ContainerSize,
      ''                                                                   as ShippingLine,
      ''                                                                   as ShippingType,
      ''                                                                   as VesselName,
      ''                                                                   as BLNo,
      ''                                                                   as BLDate,
      ''                                                                   as DocumentSentDate,
      ''                                                                   as DocumentPresentDate,
      ''                                                                   as AWBNo,
      ''                                                                   as ISFSentDate,
      ''                                                                   as EBRCNo,
      ''                                                                   as EBRCDate,
      ''                                                                   as ProfitCenter,
      ''                                                                   as LCNo,
      ''                                                                   as LCDate,
      ''                                                                   as LCIssuBank,
      IN_ElectronicDocInvcRefNmbr                                          as IRNNo,
      IN_EDocEInvcEWbillNmbr                                               as EWAYBILLNo,
      ''                                                                   as ShipBill,
      ''                                                                   as ShipBillDate,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      0                                                                    as DisInDC,
      0                                                                    as DisInLC,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      0                                                                    as EXInsurance,
      //        @Semantics.amount.currencyCode: 'TransactionCurrency'
      0                                                                    as FInsuranceINDc,
      ''                                                                   as PortOfDischarge,
      ''                                                                   as Container,
      ''                                                                   as Material,
      ''                                                                   as MaterialGrp,
      cast('' as abap.unit(3))                                             as WeightUnit,

      cast(0 as abap.dec(15,3))                                            as NetWeight,

      ''                                                                   as CustomerPo,
      ''                                                                   as CustomerPoDate,
      ''                                                                   as CustomerPOLineNo,
      ''                                                                   as BillingDocDate,
      cast('' as abap.unit(3))                                             as wtunit,


      cast(0  as abap.dec(13,3))                                           as eachgrowt,

      ''                                                                   as CountOfDest,
      a.GLAccount,
      a.GLAccountName,
      ''                                                                   as DocumentReferenceID,
      ''                                                                   as CommInvRef,
      ''                                                                   as salesperson,
      ''                                                                   as etadt,
      ''                                                                   as AccountingDocument


}
