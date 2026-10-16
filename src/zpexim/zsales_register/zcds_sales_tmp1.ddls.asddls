@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS for Sales Register'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZCDS_SALES_TMP1
  as select distinct from ZCDS_SALES_TMP4              as A

    left outer join       I_BillingDocumentItem        as B  on A.BillingDocument  =  B.BillingDocument

    left outer join       I_DeliveryDocumentItem       as bb on B.SalesDocument = bb.ReferenceSDDocument

    left outer join       I_SalesOrder                 as C  on B.SalesDocument = C.SalesOrder

    left outer join       I_Customer                   as cc on A.PayerParty = cc.Customer

    left outer join       I_CustomerReturn             as ca on B.SalesDocument = ca.CustomerReturn

    left outer join       I_CustomerReturnDeliveryItem as cb on B.BillingDocument = cb.ReferenceSDDocument

    left outer join       I_RegionText                 as E  on  E.Region   = cc.Region
                                                             and E.Country  = cc.Country
                                                             and E.Language = $session.system_language

    left outer join       ZI_TmgForSalesGrpPerso       as F  on  B.SalesGroup            = F.Salesgroup
                                                             and F.ConfigDeprecationCode is initial

    left outer join       ZI_DELDASH_HDR               as D  on  B.ReferenceSDDocument =  D.Delivery
                                                             and D.Canind              <> 'X'

    left outer join       I_ProductPlantBasic          as G  on  B.Product = G.Product
                                                             and B.Plant   = G.Plant

    left outer join       ZCDS_SALES5                  as H  on  B.BillingDocument     = H.BillingDocument
                                                             and B.BillingDocumentItem = H.BillingDocumentItem

    left outer join       I_CustomerPaymentTermsText   as I  on  A.CustomerPaymentTerms = I.CustomerPaymentTerms
                                                             and I.Language             = $session.system_language

    left outer join       ZI_DELDASH_HDR               as J  on  B.ReferenceSDDocument =  J.Delivery
                                                             and J.Canind              <> 'X'

    left outer join       I_ProfitCenterText           as L  on  B.ProfitCenter = L.ProfitCenter
                                                             and L.Language     = $session.system_language

    left outer join       ZI_LCEXPITM                  as M  on B.ReferenceSDDocument = M.Delivery

    left outer join       ZI_LCEXPHEAD                 as N  on  M.Id        =  N.Id
                                                             and N.Lc_Status <> 'CLOSE'

    left outer join       ZI_LCBNK_DLTS                as O  on  M.Id       = O.Id
                                                             and O.Banktype = 'Issuing Bank'

    left outer join       ZCDS_SHIPPING                as Q  on A.BillingDocument = Q.Invoice

    left outer join       ZV_SALESREGPACKLIST          as T  on  D.Delivery                = T.Delivery
                                                             and B.ReferenceSDDocumentItem = T.Posnr
    left outer join       ztmg_salesgrp                as X  on  C.SalesGroup            = X.salesgroup
                                                             and X.configdeprecationcode is initial
    left outer join       ztmg_salesgrp                as Y  on  bb.SalesGroup           = Y.salesgroup
                                                             and Y.configdeprecationcode is initial
    left outer join       ztmg_salesgrp                as Z  on  B.SalesGroup            = Z.salesgroup
                                                             and Z.configdeprecationcode is initial


{
  key A.BillingDocument                                                                                                                        as GstInvoice,
  key B.BillingDocumentItem,
      A.CompanyCode,
      A.FiscalYear,

      case
           when A.BillingDocumentType = 'G2'
           then cast('CN' as abap.char(10))
           when A.BillingDocumentType = 'L2'
           then cast('DN' as abap.char(10))
           when A.BillingDocumentType = 'CBRE'
           then cast('CN' as abap.char(10))
           when B.SDDocumentReason = 'Z01'
           then cast('Service' as abap.char(10))
           when B.SDDocumentReason = 'Z02'
           then cast('Service' as abap.char(10))
           when B.SDDocumentReason = 'Z03'
           then cast('Service' as abap.char(10))
           when A.DistributionChannel = 'EX'
           then cast('Export' as abap.char(10))
           when A.DistributionChannel = 'ME'
           then cast('Merchant' as abap.char(10))
           when A.DistributionChannel = 'DO'
           then cast('Domestic' as abap.char(10))  end                                                                                         as InvoiceType,

      A.BillingDocumentDate                                                                                                                    as GstInvDate,
      A.SalesOrganization                                                                                                                      as SalesOrg,
      A.PayerParty                                                                                                                             as BPCode,
      A.AccountingExchangeRate                                                                                                                 as ExchangeRate,
      //      A.BillingDocumentDate                                               as BillingDocDate,
      A.CreationDate                                                                                                                           as BillingDocDate,
      B.Division,
      B.MaterialGroup,
      B.SDDocumentReason,
      A.BillingDocumentType,
      case B.Plant
      when '1100'
      then  cast('SALAP' as abap.char(10))
      when '1200'
      then  cast('KULGACHIA' as abap.char(10))
      when '1300'
      then  cast('BAGNAN' as abap.char(10))
      when '1400'
      then  cast('BARODA' as abap.char(10))
      when '1000'
      then  cast('KOLKATA HO' as abap.char(10))
      when '2000'
      then  cast('DUBAI' as abap.char(10)) end                                                                                                 as ShipmentLocation,

      B.SalesDocument                                                                                                                          as SalesOrderNumber,
      B.SalesDocumentItem,
      B.Product                                                                                                                                as Material,

      case when B.ReferenceSDDocumentCategory = 'H'
      then cb.CustomerReturnDelivery
      else D.Delivery     end                                                                                                                  as OutboundDeliveryNo,

      case when B.ReferenceSDDocumentCategory = 'H'
      then cb.CustomerReturnDeliveryItem
      else B.ReferenceSDDocumentItem     end                                                                                                   as OutboundDeliveryItemNo,

      B.TransactionCurrency                                                                                                                    as Currency,
      B.BillingDocumentItemText                                                                                                                as ItemDescription,
      B.BillingQuantityUnit                                                                                                                    as UOM,

      @Semantics.quantity.unitOfMeasure: 'UOM'
      B.BillingQuantity                                                                                                                        as Qty,

      @Semantics.quantity.unitOfMeasure: 'Uom'
      cast(B.ItemNetWeight  / ( case when coalesce(B.BillingQuantity,0) = 0 then 1 else coalesce(B.BillingQuantity,0) end ) as abap.dec(10,2)) as unitWeight,

      //    (B.ItemNetWeight  b.BillingQuantityUnit)     as TotalWeight,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      B.ItemGrossWeight                                                                                                                        as GrossWeight,

      @Semantics.quantity.unitOfMeasure: 'Uom'
      B.ItemNetWeight                                                                                                                          as TransNetWt,

      case
      when C.SalesOrderDate is null
      then ca.CreationDate
      //      when C.SalesOrderDate = ' '
      //      then ca.CreationDate
      else C.SalesOrderDate end                                                                                                                as SalesOrderDate,

      cc.CustomerName                                                                                                                          as BPName,
      cc.TaxNumber3                                                                                                                            as GSTInNo,
      substring( cc.TaxNumber3, 3, 10 )                                                                                                        as PANNo,
      E.RegionName                                                                                                                             as StateName,
      D.Salesnoteref                                                                                                                           as SaleNoteRef,
      D.Conname                                                                                                                                as ContaionerName,
      D.Cod                                                                                                                                    as CountOfDest,
      F.Salesperson                                                                                                                            as SalesEmpName,
      G.Plant,
      G.ConsumptionTaxCtrlCode                                                                                                                 as HSNCODE,
      H.TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      ( coalesce( H.sum_a, cast( 0 as abap.curr( 15, 2 ))) - coalesce( H.sum_b,cast( 0 as abap.curr( 15, 2 )) ) - coalesce(H.sum_c,cast( 0 as abap.curr( 15, 2 )) )) as ValueInDC,
      H.sum_a                                                                                                                                  as ValueInDC,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      ( coalesce( H.sum_a, cast( 0 as abap.curr( 15, 2 ))) - coalesce( H.sum_b,cast( 0 as abap.curr( 15, 2 )) ) - coalesce(H.sum_c,cast( 0 as abap.curr( 15, 2 )) )) as ValueInDcComm,
      H.sum_a                                                                                                                                  as ValueInDcComm,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      H.DISC                                                                                                                                   as DISC,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      H.ExportFreight                                                                                                                          as ExportFreight,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      H.ExportFreight                                                                                                                          as EXInsurance,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      H.ExportFreight                                                                                                                          as FInsuranceINDc,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      H.IGSTAmount                                                                                                                             as IGSTAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      H.CGSTAmount                                                                                                                             as CGSTAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      H.SGSTAmount                                                                                                                             as SGSTAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      H.DISCinDc                                                                                                                               as DisInDC,
      // Added by SP on 16.06.25
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      H.TCSAmount                                                                                                                              as TCSAmount,
      // End of Added by SP on 16.06.25
      I.CustomerPaymentTermsName                                                                                                               as PayTerms,
      J.Stuffdt                                                                                                                                as StuffingDate,
      J.Pol                                                                                                                                    as PortOfLoading,
      J.Findes                                                                                                                                 as FinalDestination,
      J.Consizen                                                                                                                               as ContainerSize,
      J.Shipline                                                                                                                               as ShippingLine,
      A.IncotermsLocation1                                                                                                                     as ShippingType,
      J.Pod                                                                                                                                    as PortOfDischarge,
      J.Contno                                                                                                                                 as Container,
      //      K.Vesselname                                                                                                                                                   as VesselName,
      //      K.Ladingno                                                                                                                                                     as BLNo,
      //      K.Ladingdt                                                                                                                                                     as BLDate,
      //      K.Docsentcustdt                                                                                                                                                as DocumentSentDate,
      //      K.Docpresentbnkdt                                                                                                                                              as DocumentPresentDate,
      //      K.Awbno                                                                                                                                                        as AWBNo,
      //      K.Isfsenddt                                                                                                                                                    as ISFSentDate,
      //      K.Ebrcno                                                                                                                                                       as EBRCNo,
      //      K.Ebrcrcvdt                                                                                                                                                    as EBRCDate,
      L.ProfitCenterName                                                                                                                       as ProfitCenter,
      L.ControllingArea,
      L.ValidityEndDate,
      N.Lc_Appl                                                                                                                                as LCNo,
      N.Lc_Open_Dt                                                                                                                             as LCDate,
      O.Banka                                                                                                                                  as LCIssuBank,
      //      P.IN_ElectronicDocInvcRefNmbr                                                                                                                                  as IRNNo,
      //      P.IN_EDocEInvcEWbillNmbr                                                                                                                                       as EWAYBILLNo,
      Q.ShipBill                                                                                                                               as ShipBill,
      Q.ShipBillDate                                                                                                                           as ShipBillDate,

      D.Id,
      T.wtunit,

      @Semantics.quantity.unitOfMeasure: 'wtunit'
      T.Growt                                                                                                                                  as eachgrowt,

      B.ReferenceSDDocumentCategory,
      A.DocumentReferenceID,
      case
           when A.BillingDocumentType = 'G2'
             or A.BillingDocumentType = 'CBRE'
             or A.BillingDocumentType = 'L2'
           then Z.salesperson

           when B.SDDocumentReason = 'Z01'
             or B.SDDocumentReason = 'Z02'
             or B.SDDocumentReason = 'Z03'
           then Y.salesperson

           when A.DistributionChannel = 'EX'
             or A.DistributionChannel = 'DO'
           then X.salesperson

           else X.salesperson end                                                                                                              as salesperson,

      J.Etadt
}

where
           A.BillingDocumentType         =  'F8'
  or       A.BillingDocumentType         =  'G2'
  or       A.BillingDocumentType         =  'L2'
  or       A.BillingDocumentType         =  'CBRE'
  or(
           A.BillingDocumentType         =  'F2'
    and(
           B.Division                    =  'PT'
      or   B.MaterialGroup               =  'Z001'
      or   B.SDDocumentReason            =  'Z01'
    )
    or(
           A.BillingDocumentType         =  'F2'
      and(
           B.Division                    =  'AS'
        or B.MaterialGroup               =  'Z040'
        or B.SDDocumentReason            =  'Z06'
      )
    )
  )

  and      A.AccountingTransferStatus    != 'E'

  and(
           B.ReferenceSDDocumentCategory =  'J'
    or     B.ReferenceSDDocumentCategory =  'H'
    or     B.ReferenceSDDocumentCategory =  'C'
  )

  and      A.CancelledBillingDocument    =  ''

  and      A.BillingDocumentIsCancelled  =  ''
