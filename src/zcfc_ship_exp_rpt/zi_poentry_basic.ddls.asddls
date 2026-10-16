@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for PO Entry Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_POENTRY_BASIC
  as select distinct from I_ServiceEntrySheetAPI01      as a
    inner join            ZI_COMMINVDATE                as l on a.ServiceEntrySheetName = l.Commid
    inner join            I_ServiceEntrySheetItemAPI01  as b on  a.PurchaseOrder     =  b.PurchaseOrder
                                                             and a.ServiceEntrySheet =  b.ServiceEntrySheet
                                                             and a.IsDeleted         <> 'X'
    left outer join       I_Supplier                    as c on a.Supplier = c.Supplier
    left outer join       I_BusinessUserBasic           as d on d.UserID = b.CreatedByUser
    left outer join       I_BusinessUserBasic           as e on e.UserID = b.LastChangedByUser
    left outer join       ZI_SHPINVAMT                  as f on  a.PurchaseOrder         = f.Servicepo
                                                             and b.PurchaseOrderItem     = f.Servicepoline
                                                             and a.ServiceEntrySheetName = f.Commid
                                                             and b.ServiceEntrySheet     = f.ServiceEntrySheet
    inner join            I_PurchaseOrderItemAPI01      as g on  b.PurchaseOrder     = g.PurchaseOrder
                                                             and b.PurchaseOrderItem = g.PurchaseOrderItem
    left outer join       I_SuplrInvcItmAcctAssgmtAPI01 as h on  f.SupplierInvoice     = h.SupplierInvoice
                                                             and f.SupplierInvoiceItem = h.SupplierInvoiceItem
                                                             and f.FiscalYear          = h.FiscalYear
    left outer join       I_CostCenterText              as i on h.CostCenter = i.CostCenter
    left outer join       I_GLAccountText               as j on  h.GLAccount = j.GLAccount
                                                             and j.Language  = 'E'
    left outer join       I_SupplierInvoiceAPI01        as k on  f.SupplierInvoice = k.SupplierInvoice
                                                             and f.FiscalYear      = k.FiscalYear
  //    left outer join       I_JournalEntryItem            as m on  a.PurchaseOrder     = m.PurchasingDocument
  //                                                             and b.PurchaseOrderItem = m.PurchasingDocumentItem
  //                                                             and h.GLAccount         = m.GLAccount
  //                                                             and a.Supplier          = m.Supplier
  //                                                             and m.SourceLedger      = '2L'
  //    inner join            I_JournalEntry                as n on m.AccountingDocument = m.AccountingDocument





{
  key    a.ServiceEntrySheetName                                                            as Commid,
  key    '2'                                                                                as SlNo,
  key    'PO Entry'                                                                         as Type,
  key    cast( concat( b.ServiceEntrySheet,b.ServiceEntrySheetItem ) as abap.char( 32 ) )   as Item,
  key    h.CostCenter                                                                       as CC,
  key    l.Commdate                                                                         as Commdate,
  key    ''                                                                                 as Profitcenter,
  key    ''                                                                                 as ProfitCenterName,
  key    ''                                                                                 as Expansetype,
  key    ''                                                                                 as Percontship,
  key    a.Supplier                                                                         as Forwarder,
  key    c.SupplierName,
  key    ''                                                                                 as SupplierInvoice,
  key    b.ServiceEntrySheet                                                                as ReferenceDocument,
  key    g.Material                                                                         as SupplierMaterialNumber,
         ( case when ( b.ConfirmedQuantity is initial or b.ConfirmedQuantity is null )
                then cast ( 0  as abap.dec( 19,3 ) )
                else cast ( b.ConfirmedQuantity as abap.dec( 19,3 ) ) end )                 as countcontship,
         cast ( b.NetAmount as abap.dec( 13, 3 ))                                           as Amount,
         b.Currency                                                                         as Currency,
         cast ( ( case when b.Currency = 'INR' then 1.000 end ) as abap.dec( 13, 3 ))       as Exchangerate,
         cast ( ( case when b.Currency = 'INR' then b.NetAmount end ) as abap.dec( 13, 3 )) as Amountinr,
         b.PurchaseOrder                                                                    as Servicepo,
         b.PurchaseOrderItem                                                                as Servicepoline,
         cast ( g.NetPriceAmount as abap.dec( 13, 3 ))                                      as POAmt,
         g.DocumentCurrency                                                                 as POCurr,
         cast ( f.InvAmt as abap.dec( 13, 3 ))                                              as InvAmt,
         f.DocumentCurrency,
         g.MaterialGroup,
         g.PurchaseOrderItemText,
         //         k.DocumentDate,
         k.PostingDate,
         d.PersonFullName                                                                   as CreatedByUser,
         e.PersonFullName                                                                   as LastChangedByUser,
         //         k.SupplierPostingLineItemText,
         h.CostCenter                                                                       as CostCenterCode,
         i.CostCenterName                                                                   as CostCenter,
         h.GLAccount                                                                        as GLCode,
         j.GLAccountName                                                                    as GLName

}
