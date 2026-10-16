@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View of Open SO Report - Insia'
@Search.searchable: true
define view entity ZC_OPNSPINSIARPT
  as select distinct from ZI_OPNSPINSIARPT
{
              @EndUserText.label: 'Customer Code'
  key         cust_code,
              @Search.defaultSearchElement: true
              @EndUserText.label: 'SO No'
  key         SalesOrder,
              @EndUserText.label: 'Material Code'
  key         matcode,
              @EndUserText.label: 'Material Description'
  key         matdes,
              @EndUserText.label: 'Customer PO No.'
  key         Cust_PO_No,
              @EndUserText.label: 'Customer PO Line No.'
              Cust_PO_Line_No,
              @EndUserText.label: 'Customer Description'
              custdes,
              @EndUserText.label: 'SO Date'
              salesdate,
              @EndUserText.label: 'Creation Date'
              createdate,
              @EndUserText.label: 'Update Date'
              updatedate,
              @UI.hidden: true
              OrderQuantityUnit,
              @EndUserText.label: 'Order Quantity'
              OrderQty,
              @UI.hidden: true
              WeightUnit,
              @EndUserText.label: 'Order Wt'
              Order_wt,
              @EndUserText.label: 'Delivered Qty'
              DelQty,
              @EndUserText.label: 'Delivered Wt'
              Delivered_Wt,
              @EndUserText.label: 'Balance Qty'
              BalQty,
              @EndUserText.label: 'Balance Wt'
              Balance_Wt





}
