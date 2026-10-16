@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Service Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SERVICEENTRY
  as select distinct from ZI_EXPENSECAL                 as a
    left outer join       I_ProfitCenterText            as b on  a.Profitcenter = b.ProfitCenter
                                                             and b.Language     = 'E'
    inner join            ZI_EXPENSECAL_I               as c on a.Commid = c.Commid
    left outer join       I_SuplrInvcItemPurOrdRefAPI01 as d on  c.Servicepo     = d.PurchaseOrder
                                                             and c.Servicepoline = d.PurchaseOrderItem
    left outer join       I_PurchaseOrderItemAPI01      as e on  c.Servicepo     = e.PurchaseOrder
                                                             and c.Servicepoline = e.PurchaseOrderItem
    left outer join       I_SupplierInvoiceAPI01        as f on  d.SupplierInvoice = f.SupplierInvoice
                                                             and d.FiscalYear      = f.FiscalYear
    left outer join       I_SuplrInvcItmAcctAssgmtAPI01 as g on  f.SupplierInvoice     = g.SupplierInvoice
                                                             and d.SupplierInvoiceItem = g.SupplierInvoiceItem
                                                             and f.FiscalYear          = g.FiscalYear
    left outer join       I_Supplier                    as h on c.Forwarder = h.Supplier
    left outer join       I_BusinessUserBasic           as i on i.UserID = f.CreatedByUser
    left outer join       I_BusinessUserBasic           as j on j.UserID = f.LastChangedByUser
    left outer join       I_CostCenterText              as k on g.CostCenter = k.CostCenter
    left outer join       I_GLAccountText               as l on  g.GLAccount = l.GLAccount
                                                             and l.Language  = 'E'

{
  key    a.Commid,
  key    '1'                                                                                                                                                                 as SlNo,
  key    'Service Entry'                                                                                                                                                     as Type,
  key    cast( bintohex( c.Item ) as abap.char( 32 ) )                                                                                                                       as Item,
  key    g.CostCenter                                                                                                                                                        as CC,
  key    a.Commdate,
  key    a.Profitcenter,
  key    b.ProfitCenterName,
  key    c.Expansetype,
  key    c.Percontship,
  key    c.Forwarder,
  key    h.SupplierName,
  key    d.SupplierInvoice,
  key    d.ReferenceDocument,
  key    e.SupplierMaterialNumber,
         ( case when ( c.countcontship is initial or c.countcontship is null ) 
                then cast ( 0  as abap.dec( 19,3 ) ) 
                else cast ( c.countcontship  as abap.dec( 19,3 ) ) end ) as countcontship,
         cast ( c.Amount as abap.dec( 13, 3 ))                                                                                                                               as Amount,
         c.Currency,
         c.Exchangerate,
         c.Amountinr,
         c.Servicepo,
         cast ( c.Servicepoline as abap.char( 5 ) )                                                                                                                          as Servicepoline,
         cast ( e.NetPriceAmount as abap.dec( 13, 3 ))                                                                                                                       as POAmt,
         e.DocumentCurrency                                                                                                                                                  as POCurr,
         cast ( d.SupplierInvoiceItemAmount as abap.dec( 13, 3 ))                                                                                                            as InvAmt,
         d.DocumentCurrency,
         e.MaterialGroup,
         e.PurchaseOrderItemText,
         f.DocumentDate,
         f.PostingDate,
         i.PersonFullName                                                                                                                                                    as CreatedByUser,
         j.PersonFullName                                                                                                                                                    as LastChangedByUser,
         f.SupplierPostingLineItemText,
         g.CostCenter                                                                                                                                                        as CostCenterCode,
         k.CostCenterName                                                                                                                                                    as CostCenter,
         g.GLAccount                                                                                                                                                         as GLCode,
         l.GLAccountName                                                                                                                                                     as GLName

}
where
  c.Serentrysheet is not null
