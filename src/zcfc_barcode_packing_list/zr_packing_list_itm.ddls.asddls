@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PACKING_LIST_ITM
  as select distinct from    I_DeliveryDocumentItem    as _DeliveryDocumentItem
  //    left outer join I_ProductPlantBasic    as _ProductPlant    on  _DeliveryDocumentItem.Material      = _ProductPlant.Product
  //                                                               and _DeliveryDocumentItem.PlanningPlant = _ProductPlant.Plant
    left outer join I_ProductDescription      as _ProductDesc     on  _DeliveryDocumentItem.Material = _ProductDesc.Product
                                                                  and _ProductDesc.Language          = $session.system_language
    left outer join I_ProductPlantBasic       as _CtrlCode        on _ProductDesc.Product = _CtrlCode.Product
                                                                  
    left outer join I_AE_CnsmpnTaxCtrlCodeTxt as _CtrlDesc        on  _CtrlCode.ConsumptionTaxCtrlCode = _CtrlDesc.ConsumptionTaxCtrlCode
                                                                  and _CtrlDesc.Language               = $session.system_language
                                                                  and _CtrlDesc.CountryCode = 'IN'
    left outer join I_SalesDocument           as _SalesDocument   on _DeliveryDocumentItem.ReferenceSDDocument = _SalesDocument.SalesDocument
    left outer join ZI_PACKLIST_ITM           as _PackingListItem on  _DeliveryDocumentItem.DeliveryDocument     = _PackingListItem.Delivery
                                                                  and _DeliveryDocumentItem.DeliveryDocumentItem = _PackingListItem.Posnr
                                                                  and _DeliveryDocumentItem.Material             = _PackingListItem.Matnr

{
  key _DeliveryDocumentItem.DeliveryDocument         as DeliveryDocument,
  key _DeliveryDocumentItem.DeliveryDocumentItem     as DeliveryDocumentItem,
  key    _DeliveryDocumentItem.Material                 as Material,
      _DeliveryDocumentItem.DeliveryDocumentItemText as DeliveryDocumentItemText,
      //  _ProductPlant.ConsumptionTaxCtrlCode           as ConsumptionTaxCtrlCode,
      _CtrlDesc.ConsumptionTaxCtrlCodeText1          as ConsumptionTaxCtrlCode,
      _CtrlCode.ConsumptionTaxCtrlCode as control_code,
      _SalesDocument.PurchaseOrderByCustomer         as PurchaseOrderByCustomer,
      _SalesDocument.CustomerPurchaseOrderDate       as CustomerPurchaseOrderDate,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      _DeliveryDocumentItem.ActualDeliveryQuantity   as ActualDeliveryQuantity,
      _DeliveryDocumentItem.DeliveryQuantityUnit     as DeliveryQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      _PackingListItem.Packqty                       as PackageNumber,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      _PackingListItem.Eachnetwt                     as EachNetWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      _PackingListItem.Eachgrowt                     as EachGrossWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      _PackingListItem.Netwt                         as NetWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      _PackingListItem.Growt                         as GrossWeight,
      _PackingListItem.Packmattyp                    as PackageType,
      _PackingListItem.Wtunit                        as WeightUnit,
      _PackingListItem.Meins                         as Meins

}
