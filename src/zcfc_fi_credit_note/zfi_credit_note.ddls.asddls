@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI Credit note'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_CREDIT_NOTE
  as select distinct from I_OperationalAcctgDocItem                                         as _item
  // Join journal entries with system login language
    left outer join       I_AccountingDocumentJournal(P_Language: $session.system_language) as _JOURNAL      on  _item.CompanyCode            = _JOURNAL.CompanyCode
                                                                                                             and _item.FiscalYear             = _JOURNAL.FiscalYear
                                                                                                             and _item.AccountingDocument     = _JOURNAL.AccountingDocument
                                                                                                             and _item.AccountingDocumentItem = _JOURNAL.AccountingDocumentItem
                                                                                                             and _JOURNAL.Ledger              = '0L'
  // Join journal entries for header text with system login language
    left outer join       I_AccountingDocumentJournal(P_Language: $session.system_language) as _JOURNAL_NAR  on  _item.CompanyCode                 = _JOURNAL_NAR.CompanyCode
                                                                                                             and _item.FiscalYear                  = _JOURNAL_NAR.FiscalYear
                                                                                                             and _item.AccountingDocument          = _JOURNAL_NAR.AccountingDocument
                                                                                                             and _JOURNAL_NAR.FinancialAccountType = 'D'
  // Join GL account text in system login language
    left outer join       I_GLAccountTextRawData                                            as _gl           on  _item.GLAccount = _gl.GLAccount
                                                                                                             and _gl.Language    = $session.system_language
  // Join product description (non-empty products only)
    left outer join       I_ProductDescription                                              as _desc         on  _item.Product =  _desc.Product
                                                                                                             and _desc.Product is not null
                                                                                                             and _desc.Product <> ''
  // Product plant data
    left outer join       I_ProductPlantBasic                                               as _basic        on _item.Product = _basic.Product
  // Purchase order item details
    left outer join       I_PurchaseOrderItemAPI01                                          as _net          on  _item.PurchasingDocument     = _net.PurchaseOrder
                                                                                                             and _item.PurchasingDocumentItem = _net.PurchaseOrderItem
  // GST Amount Views: CGST
    left outer join       ZFI_CDNT_CGST                                                     as _cgst         on  _item.CompanyCode            = _cgst.CompanyCode
                                                                                                             and _item.FiscalYear             = _cgst.FiscalYear
                                                                                                             and _item.AccountingDocument     = _cgst.AccountingDocument
                                                                                                             and _item.TaxItemAcctgDocItemRef = _cgst.TaxItemAcctgDocItemRef
  // GST Amount Views: SGST
    left outer join       ZFI_CDNT_SGST                                                     as _sgst         on  _item.CompanyCode            = _sgst.CompanyCode
                                                                                                             and _item.FiscalYear             = _sgst.FiscalYear
                                                                                                             and _item.AccountingDocument     = _sgst.AccountingDocument
                                                                                                             and _item.TaxItemAcctgDocItemRef = _sgst.TaxItemAcctgDocItemRef
  // GST Amount Views: IGST
    left outer join       ZFI_CDNT_IGST                                                     as _igst         on  _item.CompanyCode            = _igst.CompanyCode
                                                                                                             and _item.FiscalYear             = _igst.FiscalYear
                                                                                                             and _item.AccountingDocument     = _igst.AccountingDocument
                                                                                                             and _item.TaxItemAcctgDocItemRef = _igst.TaxItemAcctgDocItemRef
  // Customer master
    left outer join       I_Customer                                                        as _cust         on _JOURNAL_NAR.Customer = _cust.Customer
  // Customer address
    left outer join       I_Address_2                                                       as _cust_addr    on _cust.AddressID = _cust_addr.AddressID
  // Customer region name
    left outer join       I_RegionText                                                      as _RegionText   on  _cust.Region         = _RegionText.Region
                                                                                                             and _RegionText.Language = $session.system_language
                                                                                                             and _RegionText.Country  = 'IN'
  // Profit/Plant Center master
    left outer join       I_ProfitCenter                                                    as _pc           on _item.ProfitCenter = _pc.ProfitCenter
  // Plant region name
    left outer join       I_RegionText                                                      as _PCRegionText on  _pc.Region             = _PCRegionText.Region
                                                                                                             and _PCRegionText.Language = $session.system_language
                                                                                                             and _PCRegionText.Country  = 'IN'
  // Business place details
    left outer join       I_IN_PlantBusinessPlaceDetail                                     as _buss         on _item.ProfitCenter = _buss.Plant

  // GST registration numbers (from item business place)
    left outer join       I_IN_BusinessPlaceTaxDetail                                       as _gst          on _item.BusinessPlace = _gst.BusinessPlace
{
      // Key fields and selection fields for UI
      @UI.selectionField: [{position: 10}]
  key _item.CompanyCode                                            as CompanyCode,
      @UI.selectionField: [{position: 20}]
  key _item.FiscalYear                                             as FiscalYear,
      @UI.selectionField: [{position: 30}]
  key _item.AccountingDocument                                     as Document_No,
  key _item.AccountingDocumentItem                                 as item_No,
      // Document dates & references
      _JOURNAL.PostingDate                                         as Document_Date,
      _JOURNAL.DocumentReferenceID                                 as ref_doc,
      _JOURNAL.DocumentDate                                        as ref_date,
      // GL account data
      _item.GLAccount                                              as GLAccount,
      _gl.GLAccountLongName                                        as GLAccountLongName,
      // Material details
      _item.IN_HSNOrSACCode                                        as HSN,
      // Currency
      _item.TransactionCurrency                                    as Currency,
      // Total price
      @Semantics.amount.currencyCode: 'Currency'
      cast(
      round(
      abs(
      coalesce(
        cast(_item.AmountInTransactionCurrency  as abap.dec(23,3)),
        cast(0                                  as abap.dec(23,3))
      )
      ),
      3
      ) as abap.dec(23,3)
      )                                                            as Total_Price,
      // CGST amount
      @Semantics.amount.currencyCode: 'Currency'
      cast(
        round(
          abs(coalesce(_cgst.AmountInAdditionalCurrency1, 0)),
          3
        ) as abap.dec(23,3)
      )                                                            as Cgst_Amt,
      // CGST rate = (CGST ÷ Total) × 100
      case
        when _cgst.AmountInAdditionalCurrency1 is null
          or _item.AbsltAmtInAdditionalCurrency1 = 0
        then cast(0 as abap.dec(23,3))
        else cast(
               round(
                 abs(
                   cast(_cgst.AmountInAdditionalCurrency1 as abap.dec(23,3))
                   / cast(_item.AbsltAmtInAdditionalCurrency1 as abap.dec(23,3))
                 * 100 ),
                 3
               ) as abap.dec(23,3)
             )
      end                                                          as Cgst_Rate,
      // SGST
      @Semantics.amount.currencyCode: 'Currency'
      cast(
        round(
          abs(coalesce(_sgst.AmountInAdditionalCurrency1, 0)),
          3
        ) as abap.dec(23,3)
      )                                                            as Sgst_Amt,
      // SGST rate = (SGST ÷ Total) × 100
      case
        when _sgst.AmountInAdditionalCurrency1 is null
          or _item.AbsltAmtInAdditionalCurrency1 = 0
        then cast(0 as abap.dec(23,3))
        else cast(
               round(
                 abs(
                   cast(_sgst.AmountInAdditionalCurrency1 as abap.dec(23,3))
                   / cast(_item.AbsltAmtInAdditionalCurrency1 as abap.dec(23,3))
                 * 100 ),
                 3
               ) as abap.dec(23,3)
             )
      end                                                          as Sgst_Rate,
      // IGST
      @Semantics.amount.currencyCode: 'Currency'
      cast(
        round(
          abs(coalesce(_igst.AmountInAdditionalCurrency1, 0)),
          3
        ) as abap.dec(23,3)
      )                                                            as Igst_Amt,
      // IGST rate = (IGST ÷ Total) × 100
      case
        when _igst.AmountInAdditionalCurrency1 is null
          or _item.AbsltAmtInAdditionalCurrency1 = 0
        then cast(0 as abap.dec(23,3))
        else cast(
               round(
                 abs(
                   cast(_igst.AmountInAdditionalCurrency1 as abap.dec(23,3))
                   / cast(_item.AbsltAmtInAdditionalCurrency1 as abap.dec(23,3))
                 * 100 ),
                 3
               ) as abap.dec(23,3)
             )
      end                                                          as Igst_Rate,
      // Customer details
      _cust.CustomerName                                           as Customer_Name,
      concat_with_space(_cust.BPAddrStreetName, _cust.CityName, 1) as Customer_Address_Line1,
      _cust._AddressRepresentation.StreetSuffixName1               as Customer_Address_Line3,
      _cust._AddressRepresentation.StreetSuffixName2               as Customer_Address_Line4,
      // Full Customer address (street + postal + region)
      concat_with_space(
        concat_with_space(_cust.BPAddrStreetName, _cust.CityName, 1),
        concat_with_space(_cust.PostalCode, _RegionText.RegionName, 1),
        1
      )                                                            as Customer_Full_Address,
      // GST & PAN
      _cust.TaxNumber3                                             as Customer_GST_No,
      substring(_cust.TaxNumber3, 3, 10)                           as Customer_PAN_No,
      _RegionText.RegionName                                       as Place_Of_Supply_City,
      // Notes
      _JOURNAL_NAR.DocumentItemText                                as Note_In_Header,
      // Plant address
      concat_with_space(_pc.StreetAddressName, _pc.CityName, 1)    as Plant_Address_Line1,
      concat_with_space(
        concat_with_space(_pc.District, _PCRegionText.RegionName, 1),
        _pc.PostalCode,
        1
      )                                                            as Plant_Address_Line2,
      // Plant state & GST
      ltrim(_pc.ProfitCenter, '0')                                 as Plant,
      _PCRegionText.RegionName                                     as Plant_State_Code,
      _item.BusinessPlace                                          as BusinessPlace,
      _gst.IN_GSTIdentificationNumber                              as GSTN_No,
      // Plant PAN
      substring(_gst.IN_GSTIdentificationNumber, 3, 10)            as PAN_No
}
where
      _JOURNAL.AccountingDocumentType  = 'DG'
  and _item.AccountingDocumentItemType = '';
