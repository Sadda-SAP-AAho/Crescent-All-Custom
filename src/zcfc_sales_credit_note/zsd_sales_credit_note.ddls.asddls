@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Credit Note'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zsd_sales_credit_note
  as select distinct from I_BillingDocument      as a
    inner join            I_BillingDocumentItem  as b    on a.BillingDocument = b.BillingDocument

    left outer join       I_ProductPlantBasic    as p    on  b.Material = p.Product
                                                         and b.Plant    = p.Plant

    
    left outer join       ZSD_SALES_CDN_BILL_TO  as c    on a.BillingDocument = c.BillingDocument

    left outer join       ZSD_SALES_CDN_SHIP_TO  as d    on a.BillingDocument = d.BillingDocument

    left outer join       ZSD_SALES_CDN_CUST_GST as e    on a.BillingDocument = e.BillingDocument

  /* === GST Joins === */
    left outer join       ZSD_CDNT_CGST          as cgst on  b.BillingDocument     = cgst.BillingDocument
                                                         and b.BillingDocumentItem = cgst.BillingDocumentItem

    left outer join       ZSD_CDNT_SGST          as sgst on  b.BillingDocument     = sgst.BillingDocument
                                                         and b.BillingDocumentItem = sgst.BillingDocumentItem

    left outer join       ZSD_CDNT_IGST          as igst on  b.BillingDocument     = igst.BillingDocument
                                                         and b.BillingDocumentItem = igst.BillingDocumentItem
  /* === UoM Text Join === */
    left outer join       I_UnitOfMeasure        as uom  on b.BillingQuantityUnit = uom.UnitOfMeasure

 

{
      /*==== Header Fields ====*/
      @UI.selectionField: [{ position: 10 }]
  key a.BillingDocument                       as document_no,
  key b.BillingDocumentItem                   as item_no,
      @UI.selectionField: [{ position: 20 }]
      a.CompanyCode                           as company_code,
      a.SalesOrganization                     as SLS_ORG,   
      @UI.selectionField: [{ position: 30 }]
      a.BillingDocumentDate                   as document_date,
//      @UI.selectionField: [{ position: 40 }]
      c.Customer                              as Payer,
      c.AddresseeFullName                     as bill_to_name,
      c.Building                              as bill_to_building,
      c.HouseNumber                           as bill_to_houseno,
      c.Street                                as bill_to_street,
      c.StreetName                            as bill_to_streetname,
      c.CityName                              as bill_to_cityname,
      c.DistrictName                          as bill_to_dist,
      c.Region                                as bill_to_region,
      c.Country                               as bill_to_country,
      d.AddresseeFullName                     as ship_to_name,
      d.Building                              as ship_to_building,
      d.HouseNumber                           as ship_to_houseno,
      d.Street                                as ship_to_street,
      d.StreetName                            as ship_to_streetname,
      d.CityName                              as ship_to_cityname,
      d.DistrictName                          as ship_to_dist,
      d.Region                                as ship_to_region,
      d.Country                               as ship_to_country,
      e.BPTaxNumber                           as pan_no,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.TotalNetAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.TotalTaxAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ( a.TotalNetAmount + a.TotalTaxAmount ) as Grand_total,
      a.TransactionCurrency,

      /*==== Item Fields ====*/

      b.Material                              as material_code,
      b.BillingDocumentItemText               as description,

      p.ConsumptionTaxCtrlCode                as hsn_sac, // HSN/SAC from I_ProductPlant
      b.BillingQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      b.BillingQuantity                       as quantity,
      uom.UnitOfMeasure_E                     as UOM,
      b.TransactionCurrency                   as Transaction_Currency,
      @Semantics.amount.currencyCode: 'Transaction_Currency'
      case
      when b.BillingQuantity <> 0
      then cast( cast( b.NetAmount as abap.dec(15,2) )
                 / cast( b.BillingQuantity as abap.dec(15,3) )
                 as abap.dec(15,2) )
      else cast( 0 as abap.dec(15,2) )
      end                                     as unit_price,
      @Semantics.amount.currencyCode: 'Transaction_Currency'
      b.NetAmount                             as total_price,
      @Semantics.amount.currencyCode: 'Transaction_Currency'
      b.TaxAmount                             as item_total_tax,

      /*==== CGGST ====*/
      cgst.CGST_Currency                      as cgst_currency,
      cgst.CGST_Rate                          as cgst_rate,
      @Semantics.amount.currencyCode: 'CGST_Currency'
      cgst.CGST_Amt                           as cgst_amt,

      /*==== SGGST ====*/
      sgst.SGST_Currency                      as sgst_currency,
      sgst.SGST_Rate                          as sgst_rate,
      @Semantics.amount.currencyCode: 'SGST_Currency'
      sgst.SGST_Amt                           as sgst_amt,

      /*==== IGGST ====*/
      igst.IGST_Currency                      as igst_currency,
      igst.IGST_Rate                          as igst_rate,
      @Semantics.amount.currencyCode: 'IGST_Currency'
      igst.IGST_Amt                           as igst_amt
}
where
       a.CompanyCode         = '1000'
  and(
       a.BillingDocumentType = 'G2'
    or a.BillingDocumentType = 'L2'
    or a.BillingDocumentType = 'CBRE'
  )
