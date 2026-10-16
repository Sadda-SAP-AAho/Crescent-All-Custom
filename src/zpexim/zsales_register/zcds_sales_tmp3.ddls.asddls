@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS for Sales Register'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZCDS_SALES_TMP3
  as select distinct from ZCDS_SALES_TMP1       as A

    left outer join       ZCDS_SALES_TMP2       as B   on  A.OutboundDeliveryNo     = B.ReferenceSDDocument
                                                       and A.OutboundDeliveryItemNo = B.ReferenceSDDocumentItem

    left outer join       ZCDS_SALES5           as bb  on  B.BillingDocument     = bb.BillingDocument
                                                       and B.BillingDocumentItem = bb.BillingDocumentItem

    left outer join       ZI_COMM_HED           as K   on B.CommercialInvNum = K.Commid

    left outer join       ZCDS_SALES6           as P   on A.GstInvoice = P.GSTInNo

    left outer join       I_SalesOrderItem      as Q   on  Q.SalesOrder     = A.SalesOrderNumber
                                                       and Q.SalesOrderItem = A.SalesDocumentItem

    left outer join       I_CustomerReturnItem  as qq  on A.SalesOrderNumber = qq.CustomerReturn

    left outer join       I_Product             as R   on A.Material = R.Product

    left outer join       ZI_JOURNALENTRY_SALES as S   on  B.CommercialInvNum = S.OriginalReferenceDocument
                                                       and B.CompanyCode      = S.CompanyCode
  //   and B.FiscalYear       = S.FiscalYear

    left outer join       ZI_JOURNALENTRY_SALES as V   on  A.GstInvoice  = V.OriginalReferenceDocument
                                                       and A.CompanyCode = V.CompanyCode
  //   and A.FiscalYear  = V.FiscalYear

    left outer join       ZV_FINGLCODE_1        as T   on  T.BillingDocument     = B.BillingDocument
                                                       and T.BillingDocumentItem = B.BillingDocumentItem
                                                       and T.SalesDocument       = B.SalesDocument
                                                       and T.SalesDocumentItem   = B.SalesDocumentItem
                                                       and T.CompanyCode         = B.CompanyCode

    left outer join       ZV_FINGLCODE_1        as U   on  U.BillingDocument     = A.GstInvoice
                                                       and U.BillingDocumentItem = A.BillingDocumentItem
                                                       and U.SalesDocument       = A.SalesOrderNumber
                                                       and U.SalesDocumentItem   = A.SalesDocumentItem
                                                       and U.CompanyCode         = A.CompanyCode
    left outer join       ZCDS_FOB_INV          as fob on B.CommercialInvNum = fob.AssignmentReference

    left outer join       zdt_pp_matinffld      as MM  on A.Material = MM.product





{
  key A.GstInvoice,

      A.BillingDocumentItem,
      A.InvoiceType,
      A.GstInvDate,
      A.BPCode,
      A.SalesOrg,
      A.ExchangeRate,
      A.ShipmentLocation,
      A.SalesOrderNumber,
      A.OutboundDeliveryNo,
      A.Currency,

      -- New Logic --
      ( case when ( R.ProductType = 'ZFG' or R.ProductType = 'ZTRD' ) then MM.matlngtxt
             else A.ItemDescription end )                                                                     as ItemDescription,

      -- Old Logic --
      //      A.ItemDescription,

      @Semantics.quantity.unitOfMeasure: 'Uom'
      case when A.InvoiceType <> 'CN' then A.Qty else -1 * A.Qty end                                          as Qty,

      A.UOM,

      @Semantics.quantity.unitOfMeasure: 'Uom'
      A.unitWeight,

      @Semantics.quantity.unitOfMeasure: 'Uom'
      case when A.InvoiceType <> 'CN' then A.GrossWeight else -1 * A.GrossWeight end                          as GrossWeight,

      A.SalesOrderDate,
      A.BPName,
      A.GSTInNo,
      A.PANNo, //Added by SP on 16.06.25
      A.StateName,
      A.SaleNoteRef,
      A.ContaionerName,
      A.SalesEmpName,
      A.Plant,
      A.HSNCODE,
      A.TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when A.InvoiceType <> 'CN' then cast(A.ValueInDC as abap.dec(23,2))
           else cast( ( -1 * A.ValueInDC ) as abap.dec(23,2) ) end                                            as ValueInDC,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when A.InvoiceType <> 'CN' then cast(bb.sum_a as abap.dec(23,2))
           else cast( ( -1 * bb.sum_a ) as abap.dec(23,2) ) end                                               as ValueInDcComm,

      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      cast(A.ValueInDcComm as abap.dec(10,2))  as ValueInDcComm,
      case when A.InvoiceType <> 'CN' then cast(A.DISC as abap.dec(23,2))
           else cast( ( -1 * A.DISC ) as abap.dec(23,2) ) end                                                 as DISC,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when A.InvoiceType <> 'CN' then cast(A.ExportFreight as abap.dec(23,2))
           else cast( ( -1 * A.ExportFreight ) as abap.dec(23,2) ) end                                        as ExportFreight,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when A.InvoiceType <> 'CN' then cast(A.EXInsurance as abap.dec(23,2))
           else cast( ( -1 * A.EXInsurance ) as abap.dec(23,2) ) end                                          as EXInsurance,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when A.InvoiceType <> 'CN' then cast(A.FInsuranceINDc as abap.dec(23,2))
           else cast( ( -1 * A.FInsuranceINDc ) as abap.dec(23,2) ) end                                       as FInsuranceINDc,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when A.InvoiceType <> 'CN' then cast(A.IGSTAmount as abap.dec(23,2))
           else cast( ( -1 * A.IGSTAmount ) as abap.dec(23,2) ) end                                           as IGSTAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when A.InvoiceType <> 'CN' then cast(A.CGSTAmount as abap.dec(23,2))
           else cast( ( -1 * A.CGSTAmount ) as abap.dec(23,2) ) end                                           as CGSTAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when A.InvoiceType <> 'CN' then cast(A.SGSTAmount as abap.dec(23,2))
           else cast( ( -1 * A.SGSTAmount ) as abap.dec(23,2) ) end                                           as SGSTAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when A.InvoiceType <> 'CN' then cast(A.DisInDC as abap.dec(23,2))
           else cast( ( -1 * A.DisInDC ) as abap.dec(23,2) ) end                                              as DisInDC,

      // Added by SP on 16.06.25
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when A.InvoiceType <> 'CN' then cast(A.TCSAmount as abap.dec(23,2))
           else cast( ( -1 * A.TCSAmount ) as abap.dec(23,2) ) end                                            as TCSAmount,
      // End of Added by SP on 16.06.25

      A.PayTerms,
      A.StuffingDate,
      A.PortOfLoading,
      A.FinalDestination,
      A.ContainerSize,
      A.ShippingLine,
      A.ShippingType,
      A.PortOfDischarge,
      A.Container,
      A.Material,
      R.ProductGroup                                                                                          as MaterialGrp,
      //      A.BLNo,
      //      A.BLDate,
      //      A.DocumentSentDate,
      //      A.DocumentPresentDate,
      //      A.AWBNo,
      //      A.ISFSentDate,
      //      A.EBRCNo,
      A.wtunit,

      @Semantics.quantity.unitOfMeasure: 'wtunit'
      A.eachgrowt,

      A.ProfitCenter,
      A.ControllingArea,
      A.ValidityEndDate,
      A.LCNo,
      A.LCDate,
      A.LCIssuBank,
      //      A.IRNNo,
      //      A.EWAYBILLNo,
      A.ShipBill,
      A.ShipBillDate,
      A.Id,
      // A.BillingDocDate,
      B.CreationDate                                                                                          as BillingDocDate,
      A.CountOfDest,
      B.CommercialInvNum,
      B.CommInvDate,
      K.Vesselcode                                                                                            as VesselName,
      K.Ladingno                                                                                              as BLNo,
      K.Ladingdt                                                                                              as BLDate,
      K.Docsentcustdt                                                                                         as DocumentSentDate,
      K.Docpresentbnkdt                                                                                       as DocumentPresentDate,
      K.Awbno                                                                                                 as AWBNo,
      K.Isfsenddt                                                                                             as ISFSentDate,
      K.Ebrcno                                                                                                as EBRCNo,
      K.Ebrcrcvdt                                                                                             as EBRCDate,
      P.IN_ElectronicDocInvcRefNmbr                                                                           as IRNNo,
      P.IN_EDocEInvcEWbillNmbr                                                                                as EWAYBILLNo,

      //      case A.ReferenceSDDocumentCategory
      //      when 'H'
      //      then qq.CustomerReturn
      //      else
      //      Q.SalesOrderItem end                     as SalesOrderItem,
      A.SalesDocumentItem                                                                                     as SalesOrderItem,

      //      Q.Product                                as Material,
      //      Q.ItemWeightUnit,
      //      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      //      Q.ItemNetWeight                          as NetWeight,
      Q.PurchaseOrderByCustomer                                                                               as CustomerPo,
      Q.CustomerPurchaseOrderDate                                                                             as CustomerPoDate,
      Q.UnderlyingPurchaseOrderItem                                                                           as CustomerPOLineNo,
      R.WeightUnit,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      R.NetWeight                                                                                             as netweight,


      case when A.InvoiceType <> 'CN' then cast(A.Qty as abap.dec(13,3))
           else cast( ( -1 * A.Qty ) as abap.dec(13,3)) end                                                   as Qty1,
      cast(R.NetWeight as abap.dec(13,3))                                                                     as netweight1,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      ( case when R.ProductType <> 'ZWST' then cast( A.TransNetWt as abap.dec(15,3) )
             else cast( 1 as abap.dec(15,3) ) end)                                                            as TransNetWt,

      case when S.AccountingDocument is not initial then S.AccountingDocument else V.AccountingDocument   end as LedgerName,
      case when T.GLAccount is not initial then T.GLAccount else U.GLAccount end                              as GLAccount,
      case when T.GLAccountName is not initial then T.GLAccountName else U.GLAccountName end                  as GLAccountName,

      A.DocumentReferenceID,
      B.CommInvRef,
      A.salesperson,
      A.Etadt,
      fob.AccountingDocument


}

//where S.IsReversal <> 'X'
