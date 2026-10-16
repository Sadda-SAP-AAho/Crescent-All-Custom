@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Sales Discount Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}


define root view entity Z_I_SLS_DCNT
  as select from    I_SalesDocument     as _head
    inner join      I_SalesDocumentItem as _item     on _head.SalesDocument = _item.SalesDocument
    left outer join zdt_pp_matinffld    as _material on _item.Material = _material.product
{


  key _head.SalesDocument                                    as SalesDocument,
  key _item.SalesDocumentItem                                as So_line_no,


      _head.SalesDocumentDate                                as Sales_Order_Date,
      _head.PurchaseOrderByCustomer                          as Customer_Po_No,
      _head.CustomerPurchaseOrderDate                        as Customer_Po_date,

      @Consumption.filter.selectionType: #RANGE
      _head.RequestedDeliveryDate                            as Cust_Reqd_Dt,

      _head.TransactionCurrency                              as Currency,
      _head.SalesOrganization                                as Salesorg,

      @Consumption.filter.selectionType: #SINGLE
      _head.SoldToParty                                      as Customer,

      _head.DistributionChannel                              as Distchan,


      _item.UnderlyingPurchaseOrderItem as PO_Line_No,
      _item.Material                                         as Material,
      _item.SalesDocumentItemText                            as Material_Description,
      _material.matsubcode                                   as Material_Sub_Code,
      _item.OrderQuantityUnit                                as Unit,

      @Semantics.quantity.unitOfMeasure: 'Unit'
      _item.OrderQuantity                                    as Order_Quantity,

      case
        when _item.OrderQuantity <> 0
        then cast( _item.ItemGrossWeight / _item.OrderQuantity as abap.dec( 13, 2 ) )
        else cast( 0 as abap.dec( 13, 2 ) )
      end                                                    as STD_Unit_Wt,


      cast( _item.ItemGrossWeight as abap.dec(13,2) )        as Total_Weight,


      cast( _item.ItemGrossWeight / 1000 as abap.dec(13,2) ) as Total_Wt_Mt

}

where
      _head.SalesOrganization     <> ''
  and _head.DistributionChannel   <> ''
  and _head.SoldToParty           <> ''
  and _head.RequestedDeliveryDate <> '00000000'
  and _item.Material              not like '%MLA%';
