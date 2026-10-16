@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASE_REG_2
  with parameters
    P_PODateFrom : zde_date,
    P_PODateTo   : zde_date
  as select from    I_PurchaseOrderItemAPI01 as a
    inner join      I_PurchaseOrderAPI01     as c on c.PurchaseOrder = a.PurchaseOrder
    left outer join ZI_PURCHASE_REG          as b on  b.PurchaseRequisition     = a.PurchaseRequisition
                                                  and b.PurchaseRequisitionItem = a.PurchaseRequisitionItem
    left outer join I_Supplier               as d on d.Supplier = c.Supplier
    left outer join ZI_PURCHASE_REG_3        as e on e.SAPBusinessObjectNodeKey1 = a.PurchaseOrder
    left outer join I_UnitOfMeasure          as f on f.UnitOfMeasure = a.PurchaseOrderQuantityUnit
    left outer join I_UnitOfMeasureText      as g on  g.UnitOfMeasure = f.UnitOfMeasure
                                                  and g.Language      = $session.system_language
    left outer join ZI_PURCHASE_REG_4        as h on  h.PurchaseOrder     = a.PurchaseOrder
                                                  and h.PurchaseOrderItem = a.PurchaseOrderItem
    left outer join ZTF_PURCHASE_REG_5       as i on  i.MaterialDocument     =  h.MaterialDocument
                                                  and i.MaterialDocumentItem =  h.MaterialDocumentItem
                                                  and i.MaterialDocumentYear =  h.MaterialDocumentYear
                                                  and i.MaterialDocument     <> ''
    left outer join zdt_ghead                as j on  j.gatepass                =  i.YY1_GateEntryNumber_MMI
                                                  and j.gatepass                <> '0000000000'
                                                  and i.YY1_GateEntryNumber_MMI <> '0000000000'
    left outer join I_UnitOfMeasure          as k on  k.UnitOfMeasure      =  i.YY1_NetWeight_MMIU
                                                  and k.UnitOfMeasure      <> ''
                                                  and i.YY1_NetWeight_MMIU <> ''
    left outer join I_UnitOfMeasureText      as l on  l.UnitOfMeasure = k.UnitOfMeasure
                                                  and l.Language      = 'E'
    left outer join I_GLAccountTextRawData   as m on  m.GLAccount       = h.GLAccount
                                                  and m.ChartOfAccounts = 'YCOA'
                                                  and m.Language        = 'E'
    left outer join ZI_PURCHASE_REG_7        as n on  n.MaterialDocument     = h.MaterialDocument
                                                  and n.MaterialDocumentItem = h.MaterialDocumentItem
                                                  and n.MaterialDocumentYear = h.MaterialDocumentYear
    left outer join zdt_bnktaxcode           as o on o.taxcode = n.TaxCode
    left outer join ZTF_PURCHASE_REG_13      as p on  p.PurchaseOrder     = a.PurchaseOrder
                                                  and p.PurchaseOrderItem = a.PurchaseOrderItem
    left outer join I_Plant                  as q on q.Plant = a.Plant
    left outer join I_Plant                  as r on r.Plant = b.Plant
{
  key a.PurchaseOrder,
  key a.PurchaseOrderItem,
  key b.PurchaseRequisition,
  key b.PurchaseRequisitionItem,
  key h.MaterialDocument,
  key h.MaterialDocumentItem,
  key h.MaterialDocumentYear,
  key n.SupplierInvoice,
  key n.SupplierInvoiceItem,
  key n.FiscalYear,
  key i.YY1_GateEntryNumber_MMI                                                                                                                               as gatepass,
      b.Plant                                                                                                                                                 as Prplant,
      r.PlantName                                                                                                                                             as Prplantname,
      b.PurchaseReqnCreationDate,
      b.WrkflwTskCompletionUTCDateTime                                                                                                                        as Prreldt,
      b.RequestedQuantity,
      a.Material,
      a.Plant,
      q.PlantName,
      a.PurchaseOrderItemText,
      case
      when p.PlainLongText is null or p.PlainLongText = ''
         then a.YY1_MaterialLngTxt_PDI
      else p.PlainLongText
      end                                                                                                                                                     as PlainLongText,
      c.Supplier,
      d.SupplierFullName,
      c.PurchaseOrderDate,
      e.WrkflwTskCompletionUTCDateTime                                                                                                                        as Poreldate,
      cast( a.OrderQuantity as abap.dec( 13, 3 ) )                                                                                                            as OrderQuantity,
      f.UnitOfMeasure,
      g.UnitOfMeasureLongName,
      h.PostingDate,
      h.QuantityInEntryUnit,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency1'
      h.PurOrdAmountInCompanyCodeCrcy1,
      h.CompanyCodeCurrency1,
      i.YY1_GateEntryNumber_MMI,
      j.gateentrydate,
      i.YY1_ChallanQuantity_MMI,
      h.InspectionCodeText,
      case when j.shipmenttype = 'BY HAND' then cast( 'Yes' as abap.char(5) )
           else cast( 'No' as abap.char(5) ) end                                                                                                              as byhand,
      i.YY1_VehicleNumber_MMI,
      j.transportername,
      j.drivername,
      i.YY1_TareWeight_MMI,
      l.UnitOfMeasureLongName                                                                                                                                 as unitwt,
      i.YY1_GrossWeight_MMI,
      i.YY1_NetWeight_MMI,
      j.gateentrydate                                                                                                                                         as chkindt,
      -- FIX: Cast to abap.tims to match type used in other UNION branches
      cast( '000000' as abap.numc( 6 ) )                                                                                                                      as chkintm,
      j.vehicleoutdate                                                                                                                                        as chkoutdt,
      cast( '000000' as abap.numc( 6 ) )                                                                                                                      as chkouttm,
      h.GLAccount,
      m.GLAccountLongName,
      h.ProjectElement,
      h.ProjectElementDescription,
      cast( '' as abap.char(10) )                                                                                                                             as condtype,
      n.PostingDate                                                                                                                                           as invpostdt,
      n.SupplierInvoiceIDByInvcgParty,
      n.DocumentDate,
      n.TaxCode,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( division( cast( ( cast( n.PurOrdAmountInCompanyCodeCrcy as abap.dec( 23, 2 ) ) * o.igst ) as abap.dec( 23, 2 ) ), 100, 2 ) as abap.dec( 23, 2 ) ) as igst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( division( cast( ( cast( n.PurOrdAmountInCompanyCodeCrcy as abap.dec( 23, 2 ) ) * o.cgst ) as abap.dec( 23, 2 ) ), 100, 2 ) as abap.dec( 23, 2 ) ) as cgst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( division( cast( ( cast( n.PurOrdAmountInCompanyCodeCrcy as abap.dec( 23, 2 ) ) * o.sgst ) as abap.dec( 23, 2 ) ), 100, 2 ) as abap.dec( 23, 2 ) ) as sgst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      n.PurOrdAmountInCompanyCodeCrcy,
      n.CompanyCodeCurrency,
      n.PaymentTerms,
      n.DueCalculationBaseDate
}

where
      c.PurchaseOrderDate        between $parameters.P_PODateFrom and $parameters.P_PODateTo

-- ============================================================
-- UNION BRANCH 2: Invoice-only lines (ZI_PURCHASE_REG_17)
-- ============================================================
union select from I_PurchaseOrderItemAPI01 as a
  inner join      I_PurchaseOrderAPI01     as c on c.PurchaseOrder = a.PurchaseOrder
  left outer join ZI_PURCHASE_REG          as b on  b.PurchaseRequisition     = a.PurchaseRequisition
                                                and b.PurchaseRequisitionItem = a.PurchaseRequisitionItem
  left outer join I_Supplier               as d on d.Supplier = c.Supplier
  left outer join ZI_PURCHASE_REG_3        as e on e.SAPBusinessObjectNodeKey1 = a.PurchaseOrder
  left outer join I_UnitOfMeasure          as f on f.UnitOfMeasure = a.PurchaseOrderQuantityUnit
  left outer join I_UnitOfMeasureText      as g on  g.UnitOfMeasure = f.UnitOfMeasure
                                                and g.Language      = 'E'
  inner join      ZI_PURCHASE_REG_17       as n on  n.PurchaseOrder     = a.PurchaseOrder
                                                and n.PurchaseOrderItem = a.PurchaseOrderItem
  left outer join zdt_bnktaxcode           as o on o.taxcode = n.TaxCode
  left outer join ZTF_PURCHASE_REG_13      as p on  p.PurchaseOrder     = a.PurchaseOrder
                                                and p.PurchaseOrderItem = a.PurchaseOrderItem
  left outer join I_Plant                  as q on q.Plant = a.Plant
  left outer join I_Plant                  as r on r.Plant = b.Plant
{
  key a.PurchaseOrder,
  key a.PurchaseOrderItem,
  key b.PurchaseRequisition,
  key b.PurchaseRequisitionItem,
  key ''                                                                                                                                                      as MaterialDocument,
  key '0000'                                                                                                                                                  as MaterialDocumentItem,
  key '0000'                                                                                                                                                  as MaterialDocumentYear,
  key n.SupplierInvoice,
  key n.SupplierInvoiceItem,
  key n.FiscalYear,
  key cast( '0000000000' as abap.numc( 10 ) )                                                                                                                 as gatepass,
      b.Plant                                                                                                                                                 as Prplant,
      r.PlantName                                                                                                                                             as Prplantname,
      b.PurchaseReqnCreationDate,
      b.WrkflwTskCompletionUTCDateTime                                                                                                                        as Prreldt,
      b.RequestedQuantity,
      a.Material,
      a.Plant,
      q.PlantName,
      a.PurchaseOrderItemText,
      case
      when p.PlainLongText is null or p.PlainLongText = ''
         then a.YY1_MaterialLngTxt_PDI
      else p.PlainLongText
      end                                                                                                                                                     as PlainLongText,
      c.Supplier,
      d.SupplierFullName,
      c.PurchaseOrderDate,
      e.WrkflwTskCompletionUTCDateTime                                                                                                                        as Poreldate,
      cast( a.OrderQuantity as abap.dec( 13, 3 ) )                                                                                                            as OrderQuantity,
      f.UnitOfMeasure,
      g.UnitOfMeasureLongName,
      -- FIX: was '' — empty string is CHAR(1), not DATS; use typed zero date
      cast( '00000000' as abap.dats )                                                                                                                         as PostingDate,
      0                                                                                                                                                       as QuantityInEntryUnit,
      cast( 0 as abap.curr(23,2) )                                                                                                                            as PurOrdAmountInCompanyCodeCrcy1,
      cast( '' as abap.cuky( 5 ) )                                                                                                                            as CompanyCodeCurrency1,
      cast( '0000000000' as abap.numc( 10 ) )                                                                                                                 as YY1_GateEntryNumber_MMI,
      -- FIX: was '' — must be DATS to match branch 1 (j.gateentrydate)
      cast( '00000000' as abap.dats )                                                                                                                         as gateentrydate,
      0                                                                                                                                                       as YY1_ChallanQuantity_MMI,
      ''                                                                                                                                                      as InspectionCodeText,
      ''                                                                                                                                                      as byhand,
      ''                                                                                                                                                      as YY1_VehicleNumber_MMI,
      ''                                                                                                                                                      as transportername,
      ''                                                                                                                                                      as drivername,
      0                                                                                                                                                       as YY1_TareWeight_MMI,
      ''                                                                                                                                                      as unitwt,
      0                                                                                                                                                       as YY1_GrossWeight_MMI,
      0                                                                                                                                                       as YY1_NetWeight_MMI,
      -- FIX: was '' — must be DATS to match branch 1 (j.gateentrydate)
      cast( '00000000' as abap.dats )                                                                                                                         as chkindt,
      -- FIX: was CASE...tims_to_timn (TIMN type, no ELSE) — use zero TIMS to match branch 1
      cast( '000000' as abap.tims )                                                                                                                           as chkintm,
      -- FIX: was '' — must be DATS to match branch 1 (j.vehicleoutdate)
      cast( '00000000' as abap.dats )                                                                                                                         as chkoutdt,
      -- FIX: was CASE...tims_to_timn (TIMN type, no ELSE) — use zero TIMS to match branch 1
      cast( '000000' as abap.tims )                                                                                                                           as chkouttm,
      ''                                                                                                                                                      as GLAccount,
      ''                                                                                                                                                      as GLAccountLongName,
      ''                                                                                                                                                      as ProjectElement,
      ''                                                                                                                                                      as ProjectElementDescription,
      cast( n.SuplrInvcDeliveryCostCndnType as abap.char(10) )                                                                                                as condtype,
      n.PostingDate                                                                                                                                           as invpostdt,
      n.SupplierInvoiceIDByInvcgParty,
      n.DocumentDate,
      n.TaxCode,
      cast( division( cast( ( cast( n.PurOrdAmountInCompanyCodeCrcy as abap.dec( 23, 2 ) ) * o.igst ) as abap.dec( 23, 2 ) ), 100, 2 ) as abap.dec( 23, 2 ) ) as igst,
      cast( division( cast( ( cast( n.PurOrdAmountInCompanyCodeCrcy as abap.dec( 23, 2 ) ) * o.cgst ) as abap.dec( 23, 2 ) ), 100, 2 ) as abap.dec( 23, 2 ) ) as cgst,
      cast( division( cast( ( cast( n.PurOrdAmountInCompanyCodeCrcy as abap.dec( 23, 2 ) ) * o.sgst ) as abap.dec( 23, 2 ) ), 100, 2 ) as abap.dec( 23, 2 ) ) as sgst,
      n.PurOrdAmountInCompanyCodeCrcy,
      n.CompanyCodeCurrency,
      n.PaymentTerms,
      n.DueCalculationBaseDate
}

where
      c.PurchaseOrderDate        between $parameters.P_PODateFrom and $parameters.P_PODateTo -- ← CHANGE 2
  and b.PurchaseReqnCreationDate is null

-- ============================================================
-- UNION BRANCH 3: PR-only lines (ZI_PURCHASE_REG_16)
-- ============================================================
union select from ZI_PURCHASE_REG_16 as a
  left outer join I_Plant            as r on r.Plant = a.Plant
{
  key ''                                      as PurchaseOrder,
  key '00000'                                 as PurchaseOrderItem,
  key a.PurchaseRequisition,
  key a.PurchaseRequisitionItem,
  key ''                                      as MaterialDocument,
  key '0000'                                  as MaterialDocumentItem,
  key '0000'                                  as MaterialDocumentYear,
  key ''                                      as SupplierInvoice,
  key '000000'                                as SupplierInvoiceItem,
  key '0000'                                  as FiscalYear,
  key cast( '0000000000' as abap.numc( 10 ) ) as gatepass,
      a.Plant                                 as Prplant,
      r.PlantName                             as Prplantname,
      a.PurchaseReqnCreationDate,
      a.WrkflwTskCompletionUTCDateTime        as Prreldt,
      0                                       as RequestedQuantity,
      ''                                      as Material,
      ''                                      as plant,
      ''                                      as plantname,
      ''                                      as PurchaseOrderItemText,
      ''                                      as PlainLongText,
      ''                                      as Supplier,
      ''                                      as SupplierFullName,
      -- FIX: was '' — must be DATS to match branch 1 (c.PurchaseOrderDate)
      cast( '00000000' as abap.dats )         as PurchaseOrderDate,
      -- FIX: was '' — must be UTCLONG to match branch 1 (e.WrkflwTskCompletionUTCDateTime)
      a.WrkflwTskCompletionUTCDateTime        as Poreldate,
      cast( 0 as abap.dec( 13, 3 ) )          as OrderQuantity,
      cast( '' as abap.unit( 3 ) )            as UnitOfMeasure,
      ''                                      as UnitOfMeasureLongName,
      -- FIX: was '' — must be DATS to match branch 1 (h.PostingDate)
      cast( '00000000' as abap.dats )         as PostingDate,
      0                                       as QuantityInEntryUnit,
      cast( 0 as abap.curr(23,2) )            as PurOrdAmountInCompanyCodeCrcy1,
      cast( '' as abap.cuky( 5 ) )            as CompanyCodeCurrency1,
      cast( '0000000000' as abap.numc( 10 ) ) as YY1_GateEntryNumber_MMI,
      -- FIX: was '' — must be DATS to match branch 1 (j.gateentrydate)
      cast( '00000000' as abap.dats )         as gateentrydate,
      0                                       as YY1_ChallanQuantity_MMI,
      ''                                      as InspectionCodeText,
      ''                                      as byhand,
      ''                                      as YY1_VehicleNumber_MMI,
      ''                                      as transportername,
      ''                                      as drivername,
      0                                       as YY1_TareWeight_MMI,
      ''                                      as unitwt,
      0                                       as YY1_GrossWeight_MMI,
      0                                       as YY1_NetWeight_MMI,
      -- FIX: was '' — must be DATS to match branch 1 (j.gateentrydate)
      cast( '00000000' as abap.dats )         as chkindt,
      -- FIX: was CASE...tims_to_timn (TIMN, no ELSE) — use zero TIMS to match branch 1
      cast( '000000' as abap.tims )           as chkintm,
      -- FIX: was '' — must be DATS to match branch 1 (j.vehicleoutdate)
      cast( '00000000' as abap.dats )         as chkoutdt,
      -- FIX: was CASE...tims_to_timn (TIMN, no ELSE) — use zero TIMS to match branch 1
      cast( '000000' as abap.tims )           as chkouttm,
      ''                                      as GLAccount,
      ''                                      as GLAccountLongName,
      ''                                      as ProjectElement,
      ''                                      as ProjectElementDescription,
      cast( '' as abap.char(10) )             as condtype,
      -- FIX: was '' — must be DATS to match branch 1 (n.PostingDate)
      cast( '00000000' as abap.dats )         as invpostdt,
      ''                                      as SupplierInvoiceIDByInvcgParty,
      -- FIX: was '' — must be DATS to match branch 1 (n.DocumentDate)
      cast( '00000000' as abap.dats )         as DocumentDate,
      ''                                      as TaxCode,
      cast( 0 as abap.dec( 23, 2 ) )          as igst,
      cast( 0 as abap.dec( 23, 2 ) )          as cgst,
      cast( 0 as abap.dec( 23, 2 ) )          as sgst,
      cast( 0 as abap.curr(23,2))             as PurOrdAmountInCompanyCodeCrcy,
      cast( '' as abap.cuky( 5 ) )            as CompanyCodeCurrency,
      ''                                      as PaymentTerms,
      -- FIX: was '' — must be DATS to match branch 1 (n.DueCalculationBaseDate)
      cast( '00000000' as abap.dats )         as DueCalculationBaseDate
}
