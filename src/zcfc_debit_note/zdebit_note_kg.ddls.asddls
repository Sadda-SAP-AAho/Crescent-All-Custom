@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debit note form for document type KG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDEBIT_NOTE_KG
  as select distinct from I_OperationalAcctgDocItem                                           as _item

  // Join journal entries with system login language
    left outer join       I_AccountingDocumentJournal( P_Language: $session.system_language ) as _JOURNAL     on  _item.CompanyCode            = _JOURNAL.CompanyCode
                                                                                                              and _item.FiscalYear             = _JOURNAL.FiscalYear
                                                                                                              and _item.AccountingDocument     = _JOURNAL.AccountingDocument
                                                                                                              and _item.AccountingDocumentItem = _JOURNAL.AccountingDocumentItem
                                                                                                              and _JOURNAL.Ledger              = '0L'
//                                                                                                              and _item.FinancialAccountType   = 'S'
//                                                                                                              and (
//                                                                                                                 _item.CostCenter              is not null
//                                                                                                                 or _item.ProfitCenter         is not null
//                                                                                                               )
//                                                                                                              and _item.GLAccount              is not null
  // Join journal entries for header text with system login language
    left outer join       I_AccountingDocumentJournal( P_Language: $session.system_language ) as _JOURNAL_NAR on  _item.CompanyCode             =  _JOURNAL_NAR.CompanyCode
                                                                                                              and _item.FiscalYear              =  _JOURNAL_NAR.FiscalYear
                                                                                                              and _item.AccountingDocument      =  _JOURNAL_NAR.AccountingDocument
                                                                                                              and _JOURNAL.Ledger               =  '0L'
//                                                                                                              and _item.FinancialAccountType    =  'S'
//                                                                                                              and (
//                                                                                                                 _item.CostCenter               is not null
//                                                                                                                 or _item.ProfitCenter          is not null
//                                                                                                               )
//                                                                                                              and _item.GLAccount               is not null
                                                                                                              and _JOURNAL_NAR.DocumentItemText <> ''
  // Join GL account text in system login language
    left outer join       I_GLAccountTextRawData                                              as _gl          on  _item.GLAccount = _gl.GLAccount
                                                                                                              and _gl.Language    = $session.system_language

  // Join product description (non-empty products only)
    left outer join       I_ProductDescription                                                as _desc        on  _item.Product =  _desc.Product
                                                                                                              and _desc.Product is not null
                                                                                                              and _desc.Product <> ''

  // Product plant data
    left outer join       I_ProductPlantBasic                                                 as _basic       on _item.Product = _basic.Product

  // Purchase order item details
    left outer join       I_PurchaseOrderItemAPI01                                            as _net         on  _item.PurchasingDocument     = _net.PurchaseOrder
                                                                                                              and _item.PurchasingDocumentItem = _net.PurchaseOrderItem

  // GST Amount Views: CGST
    left outer join       ZDebit_Note_Cgst_Amt                                                as _cgst        on  _item.CompanyCode            = _cgst.CompanyCode
                                                                                                              and _item.FiscalYear             = _cgst.FiscalYear
                                                                                                              and _item.AccountingDocument     = _cgst.AccountingDocument
                                                                                                              and _item.TaxItemAcctgDocItemRef = _cgst.TaxItemAcctgDocItemRef

  // GST Amount Views: SGST
    left outer join       ZDebit_Note_Sgst_Amt                                                as _sgst        on  _item.CompanyCode            = _sgst.CompanyCode
                                                                                                              and _item.FiscalYear             = _sgst.FiscalYear
                                                                                                              and _item.AccountingDocument     = _sgst.AccountingDocument
                                                                                                              and _item.TaxItemAcctgDocItemRef = _sgst.TaxItemAcctgDocItemRef

  // GST Amount Views: IGST
    left outer join       ZDebit_Note_Igst_Amt                                                as _igst        on  _item.CompanyCode            = _igst.CompanyCode
                                                                                                              and _item.FiscalYear             = _igst.FiscalYear
                                                                                                              and _item.AccountingDocument     = _igst.AccountingDocument
                                                                                                              and _item.TaxItemAcctgDocItemRef = _igst.TaxItemAcctgDocItemRef

  // Supplier master
    left outer join       I_Supplier                                                          as _supp        on _item.Supplier = _supp.Supplier

  // Supplier address
    left outer join       I_Address_2                                                         as _vend_addr   on _supp.AddressID = _vend_addr.AddressID

  // Supplier region name
    left outer join       I_RegionText                                                        as _RegionText  on  _supp.Region         = _RegionText.Region
                                                                                                              and _RegionText.Language = $session.system_language
                                                                                                              and _RegionText.Country  = 'IN'

  // Plant master
    left outer join       I_Plant                                                             as _plant       on _item.Plant = _plant.Plant

  // Plant address
    left outer join       I_Address_2                                                         as _add         on _plant.AddressID = _add.AddressID

  // Plant region name
    left outer join       I_RegionText                                                        as _PRegionText on  _add.Region           = _PRegionText.Region
                                                                                                              and _PRegionText.Language = $session.system_language
                                                                                                              and _PRegionText.Country  = 'IN'

  // Business place details
    left outer join       I_IN_PlantBusinessPlaceDetail                                       as _buss        on _plant.Plant = _buss.Plant

  // GST registration numbers
    left outer join       I_IN_BusinessPlaceTaxDetail                                         as _gst         on _buss.BusinessPlace = _gst.BusinessPlace

{

  key _item.CompanyCode                                            as CompanyCode,

  key _item.FiscalYear                                             as FiscalYear,

  key _item.AccountingDocument                                     as Document_No,
  key _item.AccountingDocumentItem                                 as item_No,
      // Document dates & references
      _JOURNAL.PostingDate                                         as Document_Date,
      _JOURNAL.DocumentReferenceID                                 as ref_doc,
      _JOURNAL.DocumentDate                                        as ref_date,

      // GL account data
      _item.GLAccount,
      _gl.GLAccountLongName,

      // Material details
      _item.IN_HSNOrSACCode                                        as HSN,
      //      _item.Product                                                as Material_Code,
      //      _desc.ProductDescription                                     as Material_Description,

      // Material details (show only for ItemType = 'W')
      case
        when _item.AccountingDocumentItemType = 'W'
        then _item.Product
        else ''
      end                                                          as Material_Code,

      case
        when _item.AccountingDocumentItemType = 'W'
        then _desc.ProductDescription
        else ''
      end                                                          as Material_Description,

      // Quantity & unit
      _item.BaseUnit                                               as Unit,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _item.QuantityInEntryUnit                                    as Quantity,
      _item.PurchasingDocumentPriceUnit                            as UOM,

      // Currency
      _item.TransactionCurrency                                    as Currency,

      // Unit price = total price ÷ quantity
      @Semantics.amount.currencyCode: 'Currency'
      case
        when _item.QuantityInEntryUnit is null or _item.QuantityInEntryUnit = 0
        then cast( 0 as abap.dec(23,3) )
        else cast(
               round(
                 cast( _item.AbsltAmtInAdditionalCurrency1 as abap.dec(23,3) )
                 / cast( _item.QuantityInEntryUnit           as abap.dec(23,3) ),
                 3
               ) as abap.dec(23,3)
             )
      end                                                          as Unit_Price,

      // Total price
      @Semantics.amount.currencyCode: 'Currency'
      cast(
      round(
      abs(
      coalesce(
        cast( _item.AbsltAmtInAdditionalCurrency1 as abap.dec(23,3) ),
        cast( 0                                  as abap.dec(23,3) )
      )
      ),
      3
      ) as abap.dec(23,3)
      )                                                            as Total_Price,

      // CGST amount
      @Semantics.amount.currencyCode: 'Currency'
      cast(
        round(
          abs( coalesce( _cgst.AmountInAdditionalCurrency1, 0 ) ),
          3
        ) as abap.dec(23,3)
      )                                                            as Cgst_Amt,

      // CGST rate = (CGST ÷ Total) × 100
      case
        when _cgst.AmountInAdditionalCurrency1 is null
          or _item.AbsltAmtInAdditionalCurrency1 = 0
        then cast( 0 as abap.dec(23,3) )
        else cast(
               round(
                 abs(
                   cast( _cgst.AmountInAdditionalCurrency1 as abap.dec(23,3) )
                   / cast( _item.AbsltAmtInAdditionalCurrency1 as abap.dec(23,3) )
                 * 100 ),
                 3
               ) as abap.dec(23,3)
             )
      end                                                          as Cgst_Rate,

      // SGST
      @Semantics.amount.currencyCode: 'Currency'
      cast(
        round(
          abs( coalesce( _sgst.AmountInAdditionalCurrency1, 0 ) ),
          3
        ) as abap.dec(23,3)
      )                                                            as Sgst_Amt,

      // SGST rate = (CGST ÷ Total) × 100
      case
        when _sgst.AmountInAdditionalCurrency1 is null
          or _item.AbsltAmtInAdditionalCurrency1 = 0
        then cast( 0 as abap.dec(23,3) )
        else cast(
               round(
                 abs(
                   cast( _sgst.AmountInAdditionalCurrency1 as abap.dec(23,3) )
                   / cast( _item.AbsltAmtInAdditionalCurrency1 as abap.dec(23,3) )
                 * 100 ),
                 3
               ) as abap.dec(23,3)
             )
      end                                                          as Sgst_Rate,

      // IGST
      @Semantics.amount.currencyCode: 'Currency'
      cast(
        round(
          abs( coalesce( _igst.AmountInAdditionalCurrency1, 0 ) ),
          3
        ) as abap.dec(23,3)
      )                                                            as Igst_Amt,

      // IGST rate = (IGST ÷ Total) × 100
      case
        when _igst.AmountInAdditionalCurrency1 is null
          or _item.AbsltAmtInAdditionalCurrency1 = 0
        then cast( 0 as abap.dec(23,3) )
        else cast(
               round(
                 abs(
                   cast( _igst.AmountInAdditionalCurrency1 as abap.dec(23,3) )
                   / cast( _item.AbsltAmtInAdditionalCurrency1 as abap.dec(23,3) )
                 * 100 ),
                 3
               ) as abap.dec(23,3)
             )
      end                                                          as Igst_Rate,

      // Vendor details
      _supp.SupplierName                                           as Vendor_Name,
      concat_with_space(_supp.BPAddrStreetName, _supp.CityName, 1) as Vendor_Address_Line1,
      _supp._AddressRepresentation.StreetSuffixName1               as Vendor_Address_Line3,
      _supp._AddressRepresentation.StreetSuffixName2               as Vendor_Address_Line4,

      // Full vendor address (street + postal + region)
      concat_with_space(
        concat_with_space(_supp.BPAddrStreetName, _supp.CityName, 1),
        concat_with_space(_supp.PostalCode, _RegionText.RegionName, 1),
        1
      )                                                            as Vendor_Full_Address,

      // GST & PAN
      _supp.TaxNumber3                                             as Vendor_GST_No,
      substring(_supp.TaxNumber3, 3, 10)                           as Vendor_PAN_No,
      _RegionText.RegionName                                       as Place_Of_Supply_City,

      // Notes
      _JOURNAL_NAR.DocumentItemText                                as Note_In_Header,

      // Plant PAN
      substring(_gst.IN_GSTIdentificationNumber, 3, 10)            as PAN_No,

      // Plant address
      concat_with_space(_add.HouseNumber, _add.StreetName, 1)      as Plant_Address_Line1,
      concat_with_space(_add.PostalCode, _add.CityName, 1)         as Plant_Address_Line2,

      // Plant state & GST
      _plant.Plant,
      _PRegionText.RegionName                                      as Plant_State_Code,
      _buss.BusinessPlace,
      _gst.IN_GSTIdentificationNumber                              as GSTN_No
}
where
  _JOURNAL.AccountingDocumentType = 'KG'
