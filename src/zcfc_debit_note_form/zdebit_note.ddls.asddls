@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debit note form'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'dbtSet'
define view entity ZDEBIT_NOTE
  as select distinct from I_OperationalAcctgDocItem                                           as _item

  // Join journal entries with system login language
    left outer join       I_AccountingDocumentJournal( P_Language: $session.system_language ) as _JOURNAL      on  _item.CompanyCode            = _JOURNAL.CompanyCode
                                                                                                               and _item.FiscalYear             = _JOURNAL.FiscalYear
                                                                                                               and _item.AccountingDocument     = _JOURNAL.AccountingDocument
                                                                                                               and _item.AccountingDocumentItem = _JOURNAL.AccountingDocumentItem
                                                                                                               and _JOURNAL.Ledger              = '0L'
  // Join journal entries for header text with system login language
    left outer join       I_AccountingDocumentJournal( P_Language: $session.system_language ) as _JOURNAL_NAR  on  _item.CompanyCode                 = _JOURNAL_NAR.CompanyCode
                                                                                                               and _item.FiscalYear                  = _JOURNAL_NAR.FiscalYear
                                                                                                               and _item.AccountingDocument          = _JOURNAL_NAR.AccountingDocument
                                                                                                               and _JOURNAL_NAR.FinancialAccountType = 'K'

  // Join GL account text in system login language
    left outer join       I_GLAccountTextRawData                                              as _gl           on  _item.GLAccount = _gl.GLAccount
                                                                                                               and _gl.Language    = $session.system_language

  // Join product description (non-empty products only)
    left outer join       I_ProductDescription                                                as _desc         on  _item.Product =  _desc.Product
                                                                                                               and _desc.Product is not null
                                                                                                               and _desc.Product <> ''

  // Product plant data
    left outer join       I_ProductPlantBasic                                                 as _basic        on _item.Product = _basic.Product

  // Purchase order item details
    left outer join       I_PurchaseOrderItemAPI01                                            as _net          on  _item.PurchasingDocument     = _net.PurchaseOrder
                                                                                                               and _item.PurchasingDocumentItem = _net.PurchaseOrderItem

  // GST Amount Views: CGST
    left outer join       ZDEBIT_NOTE_CGST                                                    as _cgst         on  _item.CompanyCode            = _cgst.CompanyCode
                                                                                                               and _item.FiscalYear             = _cgst.FiscalYear
                                                                                                               and _item.AccountingDocument     = _cgst.AccountingDocument
                                                                                                               and _item.TaxItemAcctgDocItemRef = _cgst.TaxItemAcctgDocItemRef

  // GST Amount Views: SGST
    left outer join       ZDEBIT_NOTE_SGST                                                    as _sgst         on  _item.CompanyCode            = _sgst.CompanyCode
                                                                                                               and _item.FiscalYear             = _sgst.FiscalYear
                                                                                                               and _item.AccountingDocument     = _sgst.AccountingDocument
                                                                                                               and _item.TaxItemAcctgDocItemRef = _sgst.TaxItemAcctgDocItemRef

  // GST Amount Views: IGST
    left outer join       ZDEBIT_NOTE_IGST                                                    as _igst         on  _item.CompanyCode            = _igst.CompanyCode
                                                                                                               and _item.FiscalYear             = _igst.FiscalYear
                                                                                                               and _item.AccountingDocument     = _igst.AccountingDocument
                                                                                                               and _item.TaxItemAcctgDocItemRef = _igst.TaxItemAcctgDocItemRef

  // Supplier master
    left outer join       I_Supplier                                                          as _supp         on _JOURNAL_NAR.Supplier = _supp.Supplier

  // Supplier address
    left outer join       I_Address_2                                                         as _vend_addr    on _supp.AddressID = _vend_addr.AddressID

  // Supplier region name
    left outer join       I_RegionText                                                        as _RegionText   on  _supp.Region         = _RegionText.Region
                                                                                                               and _RegionText.Language = $session.system_language
                                                                                                               and _RegionText.Country  = 'IN'

  // Plant master
    left outer join       I_Plant                                                             as _plant        on _item.Plant = _plant.Plant

  // Profit Center master (for KG docs)
    left outer join       I_ProfitCenter                                                      as _pc           on _item.ProfitCenter = _pc.ProfitCenter

  // Plant address
    left outer join       I_Address_2                                                         as _add          on _plant.AddressID = _add.AddressID

  // Plant region name
    left outer join       I_RegionText                                                        as _PRegionText  on  _add.Region           = _PRegionText.Region
                                                                                                               and _PRegionText.Language = $session.system_language
                                                                                                               and _PRegionText.Country  = 'IN'
    left outer join       I_RegionText                                                        as _PCRegionText on  _pc.Region             = _PCRegionText.Region
                                                                                                               and _PCRegionText.Language = $session.system_language
                                                                                                               and _PCRegionText.Country  = 'IN'

  // Business place details
    left outer join       I_IN_PlantBusinessPlaceDetail                                       as _buss         on _plant.Plant = _buss.Plant

  // GST registration numbers for
    left outer join       I_IN_BusinessPlaceTaxDetail                                         as _gst          on _buss.BusinessPlace = _gst.BusinessPlace
  // GST registration numbers for AccountingDocumentType = 'KG'
    left outer join       I_IN_BusinessPlaceTaxDetail                                         as _gst_kg       on _item.BusinessPlace = _gst_kg.BusinessPlace
{

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
      case
          when _JOURNAL.AccountingDocumentType = 'RE'
               or (
                    _JOURNAL.AccountingDocumentType = 'KG'
                    and (
                         _item.FinancialAccountType = 'S'
                         or _item.CostCenter is not null
                         or _item.ProfitCenter is not null
                    )
                  )
          then _item.GLAccount
      end                                                          as GLAccount,

      case
          when _JOURNAL.AccountingDocumentType = 'RE'
               or (
                    _JOURNAL.AccountingDocumentType = 'KG'
                    and (
                         _item.FinancialAccountType = 'S'
                         or _item.CostCenter is not null
                         or _item.ProfitCenter is not null
                    )
                  )
          then _gl.GLAccountLongName
      end                                                          as GLAccountLongName,

      // Material details
      _item.IN_HSNOrSACCode                                        as HSN,

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

      // Plant address
      case
        when _JOURNAL.AccountingDocumentType = 'KG'
        then concat_with_space(_pc.StreetAddressName, _pc.CityName, 1)
        else concat_with_space(_add.HouseNumber, _add.StreetName, 1)
      end                                                          as Plant_Address_Line1,

      case
        when _JOURNAL.AccountingDocumentType = 'KG' then
          concat_with_space(
            concat_with_space(_pc.District, _PCRegionText.RegionName, 1),
            _pc.PostalCode,
            1
          )
        else
          concat_with_space(_add.PostalCode, _add.CityName, 1)
      end                                                          as Plant_Address_Line2,

      // Plant state & GST
      case
          when _JOURNAL.AccountingDocumentType = 'RE'
              then _plant.Plant
          when _JOURNAL.AccountingDocumentType = 'KG'
              then ltrim(_pc.ProfitCenter, '0')
      end                                                          as Plant,

      case
          when _JOURNAL.AccountingDocumentType = 'RE'
              then _PRegionText.RegionName
          when _JOURNAL.AccountingDocumentType = 'KG'
              then _PCRegionText.RegionName
      end                                                          as Plant_State_Code,
      case
          when _JOURNAL.AccountingDocumentType = 'RE'
              then _buss.BusinessPlace
          else _item.BusinessPlace
      end                                                          as BusinessPlace,
      case
      when _JOURNAL.AccountingDocumentType = 'RE'
      then   _gst.IN_GSTIdentificationNumber
      when _JOURNAL.AccountingDocumentType = 'KG'
        then _gst_kg.IN_GSTIdentificationNumber
      end                                                          as GSTN_No,

      // Plant PAN
      case
          when _JOURNAL.AccountingDocumentType = 'RE'
              then substring(_gst.IN_GSTIdentificationNumber, 3, 10)
          when _JOURNAL.AccountingDocumentType = 'KG'
              then substring(_gst_kg.IN_GSTIdentificationNumber, 3, 10)
      end                                                          as PAN_No

}
where
  (
         _JOURNAL.AccountingDocumentType  = 'RE'
    and(
         _item.AccountingDocumentItemType = 'W'
      or _item.AccountingDocumentItemType = 'F'
    )
  )
  or(
         _JOURNAL.AccountingDocumentType  = 'KG'
    and  _item.AccountingDocumentItemType = ''


  );
