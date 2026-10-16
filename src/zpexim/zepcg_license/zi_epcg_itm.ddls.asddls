@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For EPCG Item'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_EPCG_ITM
  as select from zdt_epcg_item
  association to parent ZI_EPCG_HDR as _head on $projection.Id = _head.Id
{
  key zdt_epcg_item.id             as Id,
  key zdt_epcg_item.item           as Item,
      zdt_epcg_item.ecomno         as Ecomno,
      zdt_epcg_item.waers          as Waers,
      zdt_epcg_item.waersfc        as Waersfc,
      zdt_epcg_item.waersfr        as Waersfr,
      zdt_epcg_item.waersinc       as Waersinc,
      zdt_epcg_item.itemno         as Itemno,
      zdt_epcg_item.hsn            as Hsn,
      zdt_epcg_item.matdesc        as Matdesc,
      zdt_epcg_item.meins          as Meins,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      zdt_epcg_item.qty            as Qty,
      zdt_epcg_item.uom            as Uom,
      @Semantics.amount.currencyCode: 'Waersfc'
      zdt_epcg_item.dutysavevalfc  as Dutysavevalfc,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_epcg_item.dutysavevalinr as Dutysavevalinr,
      zdt_epcg_item.excrateinr     as Excrateinr,
      @Semantics.amount.currencyCode: 'Waersfc'
      zdt_epcg_item.cifvalfc       as Cifvalfc,
      @Semantics.amount.currencyCode: 'Waersfr'
      zdt_epcg_item.freightcharge  as Freightcharge,
      @Semantics.amount.currencyCode: 'Waersinc'
      zdt_epcg_item.inschange      as Inschange,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_epcg_item.cifvalinr      as Cifvalinr,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_epcg_item.excrateusd     as Excrateusd,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_epcg_item.cifvalusd      as Cifvalusd,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_epcg_item.accessval      as Accessval,
      zdt_epcg_item.dutysavper     as Dutysavper,
      zdt_epcg_item.swcessperc     as Swcessperc,
      zdt_epcg_item.igstperc       as Igstperc,
      @Semantics.amount.currencyCode: 'Waersfc'
      zdt_epcg_item.grosspricefc   as Grosspricefc,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_epcg_item.payperc        as Payperc,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_epcg_item.remdutysaveinr as Remdutysaveinr,
      zdt_epcg_item.remarks        as Remarks,

      _head

}
