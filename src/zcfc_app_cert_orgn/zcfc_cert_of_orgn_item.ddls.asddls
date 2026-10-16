@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item of Certificate of Origin'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}


@OData.entitySet.name: 'itemSet'
define view entity ZCFC_CERT_OF_ORGN_ITEM
  with parameters
    commercial_no : vbeln
  as select  from    I_BillingDocument     as _billdoc
    left outer join I_BillingDocumentItem as _item    on _billdoc.BillingDocument = _item.BillingDocument
//    left outer join ZI_DELDASH_HDR       as _deldash on _item.ReferenceSDDocument = _deldash.Delivery
//    left outer join I_ProductDescription as _prdes    on  _item.BillingDocumentItemText = _prdes.ProductDescription
//    left outer join I_ProductPlantBasic as _prba on _prba.Product = _prdes.Product and
//                                           _prba.Plant = _item.Plant
left outer join ZCFC_COO_Control_Code as _ctrl on _ctrl.BillingDocument = _item.BillingDocument
   left outer join ZI_COMM_HED as _Desc on _billdoc.BillingDocument = _Desc.Commid     
   left outer join ZI_PACKLIST_ITEM_V2 as _weight on _item.BillingDocument = _weight.BillingDocument  and _item.BillingDocumentItem = _weight.BillingDocumentItem                               
{
              @UI.lineItem: [{ position: 10 }]
              @EndUserText.label: 'number_and_date_of_invoices'
  key         _billdoc.BillingDocument      as number_and_date_of_invoices,
//              @UI.lineItem: [{ position: 20 }]
//              @EndUserText.label: 'Item_Number'
//  key         _item.BillingDocumentItem     as Item_number,
//              @UI.lineItem: [{ position: 30 }]
//              @EndUserText.label: 'Number_kind_pckgs_desc_goods'
//              _item.BillingDocumentItemText as Number_kind_pckgs_desc_goods,
              @UI.lineItem: [{ position: 40 }]
              @EndUserText.label: 'UnitofMeasure'
              _item.BaseUnit                as UnitofMeasure,
              @UI.lineItem: [{ position: 50}]
              @EndUserText.label: 'Gross_weight_or_other_quantity'
              @Semantics.quantity.unitOfMeasure: 'UnitofMeasure'
//             sum( _item.ItemGrossWeight )        as Gross_weight_or_other_quantity,
              sum(_weight.Growt) as Gross_weight_or_other_quantity,
              @UI.lineItem: [{ position: 60 }]
              @EndUserText.label: 'Origin_criteria'
              _billdoc.BillingDocumentDate  as Origin_criteria,
              @UI.lineItem: [{ position: 70 }]
              @EndUserText.label: 'Net_Weight'
              @Semantics.quantity.unitOfMeasure: 'UnitofMeasure'
//             sum( _item.ItemNetWeight )           as Net_Weight,
          sum(_weight.Netwt) as Net_Weight,
              @UI.lineItem: [{ position: 80 }]
              @EndUserText.label: 'Marks_and_number_of_packages'
//              _deldash.Cusmar               as Marks_and_number_of_packages, 
            @Semantics.quantity.unitOfMeasure: 'UnitofMeasure'
            sum(_weight.Packqty)    as Marks_and_number_of_packages,        
              @UI.lineItem: [{ position: 90 }]
              @EndUserText.label: 'Invoice_date'
              _billdoc.CreationDate               as Invoice_date,
//              @UI.lineItem: [{ position: 100 }]
//              @EndUserText.label: 'HSN Code'
//              _prba.ConsumptionTaxCtrlCode              as HSN_Code,
               _ctrl.ConsumptionTaxCtrlCode as HSN_Code,
                       @UI.lineItem: [{ position: 100 }]
              @EndUserText.label: 'Goods Description1'
              _Desc.Descgoods1 as Desc1,
                 @UI.lineItem: [{ position: 110 }]
              @EndUserText.label: 'Goods Description2'
              _Desc.Descgoods2 as Desc2,
                    @UI.lineItem: [{ position: 130 }]
              @EndUserText.label: 'Weight Unit'
              _weight.Wtunit as Weight_Unit
//               @UI.lineItem: [{ position: 140 }]
//              @EndUserText.label: 'Marks Container'
//               concat_with_space(_deldash.Cusmar,_deldash.Contno , 1) as MarksContainer
//                   _prdes.Language
              

}group by _billdoc.BillingDocument, _item.BaseUnit,_billdoc.BillingDocumentDate,
_billdoc.CreationDate  ,_ctrl.ConsumptionTaxCtrlCode, _Desc.Descgoods1,  _Desc.Descgoods2,_weight.Wtunit //_prba.ConsumptionTaxCtrlCode  ,
having
  _billdoc.BillingDocument = $parameters.commercial_no;
