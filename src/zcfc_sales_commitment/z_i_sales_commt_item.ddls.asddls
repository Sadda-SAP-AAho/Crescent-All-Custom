@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Sales Commt Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_SALES_COMMT_ITEM
  as select from zsales_commt_itm as _Item
  association to parent Z_I_Sales_Commitment as _Sales on $projection.Requestuuid = _Sales.Requestuuid
{
  key _Item.requestuuid                        as Requestuuid,
  key _Item.line_item_no                       as Line_item_no,
      _Item.customer_code                      as Customer_Code,
      _Item.customer_name                      as Customer_Name,
      _Item.plantcode                          as plantcode,
      _Item.plantname                          as plantname,
      _Item.profitcenter                       as profitcenter,
      _Item.matcode                            as matcode,
      _Item.matname                            as matname,
      cast(_Item.april_w as abap.dec( 13, 2 )) as April_w,

      cast(_Item.may_w as abap.dec( 13, 2 ))   as May_w,

      cast(_Item.june_w as abap.dec( 13, 2 ))  as June_w,

      cast(_Item.july_w as abap.dec( 13, 2 ))  as July_w,

      cast(_Item.aug_w as abap.dec( 13, 2 ))   as Aug_w,

      cast(_Item.sept_w as abap.dec( 13, 2 ))  as Sept_w,

      cast(_Item.oct_w as abap.dec( 13, 2 ))   as Oct_w,

      cast(_Item.nov_w as abap.dec( 13, 2 ))   as Nov_w,

      cast(_Item.dec_w as abap.dec( 13, 2 ))   as Dec_w,

      cast(_Item.jan_w as abap.dec( 13, 2 ))   as Jan_w,

      cast(_Item.feb_w as abap.dec( 13, 2 ))   as Feb_w,

      cast(_Item.march_w as abap.dec( 13, 2 )) as March_w,
      _Item.uom,
      _Sales.Last_changed_at                   as Last_changed_at,
      _Sales

}
