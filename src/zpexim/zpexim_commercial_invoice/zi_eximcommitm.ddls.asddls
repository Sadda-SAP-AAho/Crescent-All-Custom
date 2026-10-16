@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_EXIMCOMMITM

  as select from zexim_comm_itm

  association to parent ZI_EXIMCOMMHDR as _head on $projection.Id = _head.Id
{
  key id                  as Id,
  key item                as Item,
      invoice             as Invoice,
      invoiceitem         as Invoiceitem,
      material            as Material,
      materialdescription as Materialdescription,
      uom                 as Uom,
      @Semantics.quantity.unitOfMeasure: 'uom'
      quantity            as Quantity,
      weightuom           as Weightuom,
      @Semantics.quantity.unitOfMeasure: 'Weightuom'
      netweight           as Netweight,
      @Semantics.quantity.unitOfMeasure: 'Weightuom'
      grossweight         as Grossweight,
      @Semantics.quantity.unitOfMeasure: 'Weightuom'
      packingweight       as Packingweight,
      currency            as Currency,
      @Semantics.amount.currencyCode: 'Currency'
      rate                as Rate,
      @Semantics.amount.currencyCode: 'Currency'
      amount              as Amount,
      packageremarks      as Packageremarks,
      sizeremarks         as Sizeremarks,
      harmoniccode        as Harmoniccode,
      delivery            as Delivery,
      deliveryitem        as Deliveryitem,
      salesorder          as Salesorder,
      salesorderitem      as Salesorderitem,
      contract            as Contract,
      contractitem        as Contractitem,
      reference           as Reference,

      _head

}
