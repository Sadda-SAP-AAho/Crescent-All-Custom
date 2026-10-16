@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For SC/SO Received Report'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_SCSO_RECD_RPT
  with parameters
    p_date_low  : zde_date, // Lower bound of posting date range
    p_date_high : zde_date  // Upper bound of posting date range

  as select distinct from I_SalesDocument                as head // Header table for Sales Documents
    inner join            I_SalesDocumentItem            as item // Line Item details
                                                                              on head.SalesDocument = item.SalesDocument

  // Get Bank Name of Sold-to party
    left outer join       I_BusinessPartnerBank          as bank              on head.SoldToParty = bank.BusinessPartner

  // Get Product details
    inner join            I_Product                      as product           on item.Material = product.Product

  // Get Product Group Text in session language
    inner join            I_ProductGroupText_2           as prod_text         on  item.MaterialGroup = prod_text.ProductGroup
                                                                              and prod_text.Language = $session.system_language

  // Get pricing details for each item
    left outer join       I_SalesOrderItemPricingElement as price             on  item.SalesDocument     = price.SalesOrder
                                                                              and item.SalesDocumentItem = price.SalesOrderItem
                                                                              and (
                                                                                 price.ConditionType     = 'ZPR0'
                                                                                 or price.ConditionType  = 'ZPR1'
                                                                               )

    left outer join       I_ProfitCenterText             as _profitCenterName on  item.ProfitCenter          = _profitCenterName.ProfitCenter
                                                                              and _profitCenterName.Language = 'E'

    left outer join       I_CustomerSalesArea            as sales_area        on head.SoldToParty = sales_area.Customer

  // Fetch Sales Group - Salesperson mapping from custom table
    left outer join       ztmg_salesgrp                  as salesgrp          on  sales_area.SalesGroup          =  salesgrp.salesgroup
                                                                              and salesgrp.configdeprecationcode <> 'E'

{
      //--- Key fields ---//
  key head.SalesDocument, // Sales Document Number

      // Derive Document Type based on SD Document Category
  key case head.SDDocumentCategory
        when 'G' then 'Sales Contract'
        when 'C' then 'Direct Sales Order'
        else ' '
      end                      as doc_type,

  key item.SalesDocumentItem, // Line Item Number

      //--- Header and Item Information ---//
      head.SalesDocumentDate,   // Document Date
      head.SoldToParty,         // Sold-to Customer
      head.TransactionCurrency, // Currency used
      bank.BankName            as BankIdentification, // Customer Bank Name
      item.Material,                          // Material Number
      item.SalesDocumentItemText,             // Material Description (Line Text)
      item.Plant,                             // Supplying Plant
      salesgrp.salesperson,                   // Salesperson Name from Z-table
      item.MaterialGroup,                     // Material Group
      prod_text.ProductGroupName,             // Material Group Description

      //--- Quantity and Pricing ---//
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      item.TargetQuantity,
      //--- Quantity and Pricing ---//
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      item.OrderQuantity,

      item.BaseUnit,                          // Unit of Measure
      price.ConditionType,                    // Pricing Condition Type (e.g., PR00)
      price.ConditionRateValue as unit_price, // Unit Price

      // Calculate Total Price (in document currency)
      cast(
        coalesce(price.ConditionRateValue, 0) *
        coalesce(item.OrderQuantity, 0)
        as abap.dec(16,3)
      )                        as total_price,

      item.PriceDetnExchangeRate, // Exchange Rate for Pricing

      // Calculate Total Price in INR (converted)
      cast(
        (
          coalesce(price.ConditionRateValue, 0) *
          coalesce(item.OrderQuantity, 0) *
          coalesce(item.PriceDetnExchangeRate, 0)
        ) as abap.dec(16,2)
      )                        as total_price_inr,

      //--- Weight Details ---//
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      item.ItemGrossWeight,                   // Gross Weight

      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      item.ItemNetWeight,                     // Net Weight

      item.ItemWeightUnit, // Weight Unit
      item.ProfitCenter,
      _profitCenterName.ProfitCenterLongName
}

where
  // Restrict data within input date range
       head.SalesDocumentDate          between $parameters.p_date_low and $parameters.p_date_high




  // Only consider Sales Contract (G) or Sales Order (C)
  and(
       head.SDDocumentCategory         =  'G'
    or head.SDDocumentCategory         =  'C'
  )

  and  head.SDDocumentReason           <> 'Z07'
  and  head.CorrespncExternalReference is initial


  // Exclude rejected and referenced items
  and  item.SalesDocumentRjcnReason    =  ' '
  and  item.ReferenceSDDocument        =  ' '

  // Include only Finished Goods (ZFG) and Trade (ZTRD) materials
  and(
       product.ProductType             =  'ZFG'
    or product.ProductType             =  'ZTRD'
  );
