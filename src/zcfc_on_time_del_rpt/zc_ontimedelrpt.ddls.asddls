@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'On Time Delivery Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define root view entity ZC_ONTIMEDELRPT
  provider contract transactional_query
  as projection on ZI_ONTIMEDELRPT
{
      @EndUserText.label: 'Sales Order Number'
  key SalesOrder,

      @EndUserText.label: 'Sales Order Item'
  key SalesOrderItem,

      @EndUserText.label: 'Sales Order Date'
      sodate,

      @EndUserText.label: 'Customer Reqd. Date'
      custreqdeldate,

      @EndUserText.label: 'Our Comm. Del. Date'
      CommittedDeliveryDate,

      @EndUserText.label: 'PGI Number'
      PGINo,

      @EndUserText.label: 'PGI Posting Date'
      PGIDate,

      @EndUserText.label: 'Customer Code'
      CustCode,

      @EndUserText.label: 'Sales Person'
      SalesPerson,
      
      @EndUserText.label: 'Plant'
      Plant,
      
      @EndUserText.label: 'MOC'
      MOC,

      @EndUserText.label: 'Material Code'
      Material,

      @EndUserText.label: 'Material Description'
      MaterialDesc,

      @EndUserText.label: 'HSN Code'
      HSNCode,

      @EndUserText.label: 'UOM'
      UOM,

      @UI.hidden: true
      WeightUnit,

      @EndUserText.label: 'Unit Weight-Kg'
      NetWeight,

      @UI.hidden: true
      OrderQuantityUnit,

      @EndUserText.label: 'Ordered Qty'
      OrderQuantity,

      @EndUserText.label: 'Ordered Wt-KG'
      OrderWt,

      @UI.hidden: true
      MaterialBaseUnit,

      @EndUserText.label: 'Delivered Quantity'
      TotalPGIQty,

      @EndUserText.label: 'Delivered Wt-KG'
      TotalPGIWt,

      @EndUserText.label: 'On Time Delivered Qty'
      OnTimeDelQty,

      @EndUserText.label: 'On Time Delivered Wt-KG'
      OnTimeDelwt,

      @EndUserText.label: 'Delayed Delivered Qty'
      DelayedDelQty,

      @EndUserText.label: 'Delayed Delivered Wt-KG'
      DelayedDelwt,

      @EndUserText.label: 'Delay Days'
      DelayDays
}
