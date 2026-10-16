@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Canada Customer Invoice Item Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'itemSet'
define view entity ZCFC_Canada_Cust_Invoice_Item
  as select from    I_BillingDocument     as _billdoc
    left outer join I_BillingDocumentItem as _item   on _billdoc.BillingDocument = _item.BillingDocument
    left outer join ZI_COMM_HED           as _desc   on _billdoc.BillingDocument = _desc.Commid
    left outer join ZI_PACKLIST_ITEM_V2   as _weight on  _item.BillingDocument     = _weight.BillingDocument
                                                     and _item.BillingDocumentItem = _weight.BillingDocumentItem
{
      @UI.selectionField: [{ position: 10 }]
  key _item.BillingDocument         as BillingDocument,
  key _item.BillingDocumentItem     as Item,
      _item.Product                 as Material,
      _item.BillingDocumentItemText as Material_Desc,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      _item.BillingQuantity         as Quantity,
      _item.BaseUnit                as Uom,
      //  @Semantics.amount.currencyCode: 'Curr'
      //round( cast( _item.NetAmount as abap.dec(23,3)), 0 ) as Total,
      @Semantics.amount.currencyCode: 'Curr'
      case
        when _item.BillingQuantity = 0   then cast( 0 as abap.dec(23,3) )
        else cast(
                     round(
                       cast( _item.NetAmount as abap.dec(23,3) )
                       / cast( _item.BillingQuantity           as abap.dec(23,3) ),
                       3
                     ) as abap.dec(23,3)
                   )
            end                     as Unit_Price,
      @Semantics.amount.currencyCode: 'Curr'
      cast(
           round(
           abs(
           coalesce(
             cast( _item.NetAmount as abap.dec(23,3) ),
             cast( 0                                  as abap.dec(23,3) )
           )
           ),
           3
           ) as abap.dec(23,3)
           )                        as Total,

      _item.TransactionCurrency     as curr,
//      _desc.Descgoods1              as GoodsDescription1,
//      _desc.Descgoods2              as GoodsDescription2,
      _weight.Meins                 as Unitofmeasure,
      @Semantics.quantity.unitOfMeasure: 'Unitofmeasure'
      _weight.Growt                 as Gross_weight_or_other_quantity,
      _billdoc.BillingDocument      as Number_and_date_of_invoices,
      _billdoc.BillingDocumentDate  as Origin_criteria,
      @Semantics.quantity.unitOfMeasure: 'UnitofMeasure'
      _weight.Netwt                 as Net_Weight,
      @Semantics.quantity.unitOfMeasure: 'UnitofMeasure'
      _weight.Packqty               as number_of_packages,
      _weight.Wtunit                as Weight_Unit



}
//group by
//  _desc.Descgoods1,
//  _desc.Descgoods2,
//  _weight.Meins,
//  _billdoc.BillingDocument,
//  _billdoc.BillingDocumentDate,
//  _weight.Wtunit;
