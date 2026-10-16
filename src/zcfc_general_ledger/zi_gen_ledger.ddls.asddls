@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for General Ledger'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GEN_LEDGER

  as select distinct from I_JournalEntryItem       as a

  /*----------------------------------------------------------*/
  /* Mandatory Journal Entry Header                           */
  /*----------------------------------------------------------*/
    inner join            I_JournalEntry           as e on  a.CompanyCode        = e.CompanyCode
                                                        and a.FiscalYear         = e.FiscalYear
                                                        and a.AccountingDocument = e.AccountingDocument

  /*----------------------------------------------------------*/
  /* Transactional / calculated joins                         */
  /*----------------------------------------------------------*/

  /* PR Reference */
    left outer join       ZI_SUPINVPOPRREF         as f on  a.GLAccount              = f.GLAccount
                                                        and a.AccountingDocument     = f.JournalEntry
                                                        and a.PurchasingDocument     = f.PONo
                                                        and a.PurchasingDocumentItem = f.POItem

  /* Outbound Delivery */
    left outer join       I_OutboundDeliveryItem   as g on  e.DocumentReferenceID = g.OutboundDelivery
                                                        and a.SalesDocumentItem   = g.OutboundDeliveryItem

  /* Service Entry Sheet */
    left outer join       I_ServiceEntrySheetAPI01 as h on  h.PurchaseOrder = a.PurchasingDocument
                                                        and h.IsDeleted     is initial

  /* Service Entry Sheet Count */
    left outer join       ZI_SERENTSHTCNT          as i on  a.GLAccount          = i.GLAccount
                                                        and a.AccountingDocument = i.AccountingDocument
                                                        and a.LedgerGLLineItem   = i.LedgerGLLineItem

  /* Purchase Order Item */
    left outer join       I_PurchaseOrderItemAPI01 as k on  a.PurchasingDocument     = k.PurchaseOrder
                                                        and a.PurchasingDocumentItem = k.PurchaseOrderItem

  /* PO Item Long Text */
    left outer join       ZTBL_PO_ITEM_TEXT        as l on  a.PurchasingDocument     = l.PurchaseOrder
                                                        and a.PurchasingDocumentItem = l.PurchaseOrderItem
                                                        and l.Language               = 'E'
                                                        and l.TextObjectType         = 'F01'


  /*------------------------------------------------------------*/
  /* Associations - Text / Master Data                          */
  /*------------------------------------------------------------*/

  association [0..1] to I_ProductText              as _ProductText       on  $projection.Product   = _ProductText.Product
                                                                         and _ProductText.Language = 'E'

  association [0..1] to I_CostCenterText           as _CostCenterText    on  $projection.CostCenter   = _CostCenterText.CostCenter
                                                                         and _CostCenterText.Language = 'E'

  association [0..1] to I_ProfitCenterText         as _ProfitCenterText  on  $projection.ProfitCenter   = _ProfitCenterText.ProfitCenter
                                                                         and _ProfitCenterText.Language = 'E'

  association [0..1] to I_OffsettingAccount        as _OffsettingAccount on  $projection.OffsettingAccount = _OffsettingAccount.OffsettingAccount

  association [0..1] to I_TaxCodeText              as _TaxCodeText       on  $projection.TaxCode                  = _TaxCodeText.TaxCode
                                                                         and _TaxCodeText.TaxCalculationProcedure = '0TXIN'
                                                                         and _TaxCodeText.Language                = 'E'

  association [0..1] to I_GLAccountText            as _GLAccountText     on  $projection.GLAccount   = _GLAccountText.GLAccount
                                                                         and _GLAccountText.Language = 'E'

  association [0..1] to I_EnterpriseProjectElement as _WBS               on  $projection.WBSElementInternalID = _WBS.WBSElementInternalID


{
      /*----------------------------------------------------------*/
      /* Keys                                                     */
      /*----------------------------------------------------------*/

  key e.FiscalYear,

  key e.CompanyCode,

  key a.GLAccount,

  key _GLAccountText.GLAccountName,

  key cast(
        a.AccountingDocument
          as abap.char(10)
      )                                     as AccountingDocument,

  key a.LedgerGLLineItem,

  key h.ServiceEntrySheetName               as CommInvNo,

  key a.Product,

  key _ProductText.ProductName,


      /*----------------------------------------------------------*/
      /* Basic Information                                        */
      /*----------------------------------------------------------*/

      k.PurchaseOrderItemText               as POItemName,

      a.Supplier,

      a.Customer,

      a.Plant,


      /*----------------------------------------------------------*/
      /* Cost Center                                              */
      /*----------------------------------------------------------*/

      a.CostCenter,

      _CostCenterText.CostCenterDescription as CostCenterName,


      /*----------------------------------------------------------*/
      /* Profit Center                                            */
      /*----------------------------------------------------------*/

      a.ProfitCenter,

      _ProfitCenterText.ProfitCenterName,


      /*----------------------------------------------------------*/
      /* Accounting Information                                   */
      /*----------------------------------------------------------*/

      a.Segment,

      a.PostingDate,

      a.AccountingDocumentType,

      a.PostingKey,

      a.AccountAssignment,

      a.AccountAssignmentType,


      /*----------------------------------------------------------*/
      /* Amount                                                   */
      /*----------------------------------------------------------*/

      cast(
        division(
          cast(
            a.AmountInCompanyCodeCurrency
              as abap.dec(16,3)
          ),

          case
            when cast(
                   coalesce(
                     i.SerEntCnt,
                     0
                   ) as abap.dec(16,3)
                 ) = 0

            then cast(
                   1 as abap.dec(16,3)
                 )

            else cast(
                   i.SerEntCnt
                     as abap.dec(16,3)
                 )

          end,

          3
        )
        as abap.dec(16,3)
      )                                     as Amount,


      a.CompanyCodeCurrency,


      /*----------------------------------------------------------*/
      /* Tax                                                      */
      /*----------------------------------------------------------*/

      _TaxCodeText.TaxCodeName              as TaxCode,


      /*----------------------------------------------------------*/
      /* Offsetting Account                                       */
      /*----------------------------------------------------------*/

      a.OffsettingAccount,

      _OffsettingAccount.OffsettingAccountName,


      /*----------------------------------------------------------*/
      /* Outbound Delivery                                        */
      /*----------------------------------------------------------*/

      case
        when a.GLAccount = '0047100460'
          or a.GLAccount = '0047100470'
          or a.GLAccount = '0047100550'
          or a.GLAccount = '0047100570'
          or a.GLAccount = '0047100580'
          or a.GLAccount = '0047100590'
          or a.GLAccount = '0047100610'

        then e.DocumentReferenceID

      end                                   as OutboundDelNo,


      case
        when a.GLAccount = '0047100460'
          or a.GLAccount = '0047100470'
          or a.GLAccount = '0047100550'
          or a.GLAccount = '0047100570'
          or a.GLAccount = '0047100580'
          or a.GLAccount = '0047100590'
          or a.GLAccount = '0047100610'

        then cast(
               g.ActualDeliveredQtyInBaseUnit
                 as abap.dec(16,3)
             )

      end                                   as OutboundDelQty,


      case
        when a.GLAccount = '0047100460'
          or a.GLAccount = '0047100470'
          or a.GLAccount = '0047100550'
          or a.GLAccount = '0047100570'
          or a.GLAccount = '0047100580'
          or a.GLAccount = '0047100590'
          or a.GLAccount = '0047100610'

        then g.BaseUnit

      end                                   as QtyUOM,


      /*----------------------------------------------------------*/
      /* Purchase Order                                           */
      /*----------------------------------------------------------*/

      case
        when k.PurchaseOrderItemText is not initial
        then k.PurchaseOrder

        else h.PurchaseOrder

      end                                   as PurchaseOrder,


      /*----------------------------------------------------------*/
      /* PR / PO Text                                              */
      /*----------------------------------------------------------*/

      f.PRShortText                         as PRShortText,

      l.PlainLongText                       as POItemText,


      /*----------------------------------------------------------*/
      /* Document Information                                     */
      /*----------------------------------------------------------*/

      a.DocumentItemText,

      a.NumberOfItems,


      /*----------------------------------------------------------*/
      /* WBS                                                       */
      /*----------------------------------------------------------*/

      a.WBSElementInternalID,

      _WBS.ProjectElement                   as WBSElement,

      _WBS.ProjectElementDescription        as WBSDesc,


      /*----------------------------------------------------------*/
      /* Quantity                                                  */
      /*----------------------------------------------------------*/

      a.BaseUnit,

      @Semantics: {
        quantity: {
          unitOfMeasure: 'BaseUnit'
        }
      }
      a.Quantity


}
where
      a.SourceLedger = '0L'
  and a.Ledger       = '0L';
