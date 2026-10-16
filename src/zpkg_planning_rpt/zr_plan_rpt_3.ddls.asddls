@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Open Contract Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_3
  as select distinct from I_SalesContractItem as a
    inner join            I_SalesContract     as b on a.SalesContract = b.SalesContract
    left outer join       I_SalesDocumentItem as c on  a.SalesContract               = c.ReferenceSDDocument
                                                   and a.SalesContractItem           = c.ReferenceSDDocumentItem
                                                   and c.ReferenceSDDocumentCategory = 'G'
    left outer join       I_SalesOrderItem    as d on  c.SalesDocument               =  d.SalesOrder
                                                   and c.SalesDocumentItem           =  d.SalesOrderItem
                                                   and a.SalesContract               =  d.ReferenceSDDocument
                                                   and a.SalesContractItem           =  d.ReferenceSDDocumentItem
                                                   and d.SDDocumentRejectionStatus   <> 'C'
                                                   and d.ReferenceSDDocumentCategory =  'G'
    left outer join       I_ProductPlantBasic as e on  e.Product = a.Product
                                                   and e.Plant   = a.Plant
{
  key a.SalesContract,
  key a.SalesContractItem,
  key (case when e.SpecialProcurementType = '40' then '1100'
                    else a.Plant end) as Plant,
      a.Product,
      @Semantics.quantity.unitOfMeasure: 'TargetQuantityUnit'
      a.TargetQuantity,
      a.TargetQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'TargetQuantityUnit'
      sum( d.OrderQuantity )          as OrderQuantity
}
where
      a.SalesDocumentRjcnReason      is initial
  and b.SalesContractValidityEndDate >= $session.system_date

group by
  a.SalesContract,
  a.SalesContractItem,
  a.Plant,
  e.SpecialProcurementType,
  a.Product,
  a.TargetQuantity,
  a.TargetQuantityUnit
