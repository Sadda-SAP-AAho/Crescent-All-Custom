@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material details from Dashboard'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_Material_details 
  with parameters
    P_SO : abap.numc(10)
    as select from    ZC_SO_CompReq_Param(P_SO: $parameters.P_SO) as _so
    left outer join ZTF_SOCompBOM(p_so: $parameters.P_SO)       as _bom on  _so.SalesOrderNo = _bom.SalesOrderNo
                                                                       and _so.SORowNumber  = _bom.SORowNumber

    left outer join  zdt_pp_matinffld as _mat on _mat.product = _bom.ComponentMaterial
{
    key _so.SalesOrderNo           as SO_No,
    key _bom.SORowNumber           as SO_Row_Number,
     _mat.product                   as Comp_mat,
        _bom.ComponentUnit,
        _mat.pltpcdboxsize,
        _mat.boltsize,
        _mat.qtypalpcdbox,
        _mat.pcspack,
        _mat.qtyboltunitcons,
        @Semantics.quantity.unitOfMeasure: 'ComponentUnit'
        _mat.qtyboltunitcons * _so.SOOpenQty as BOLT_REQD,
        @Semantics.quantity.unitOfMeasure: 'ComponentUnit'
        _mat.qtypalpcdbox * _so.SOOpenQty as PALLET_REQD
    
}
