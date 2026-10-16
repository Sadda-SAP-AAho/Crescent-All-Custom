@AbapCatalog.sqlViewName: 'ZTTLORDRQTY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Total Order Qty'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_TTLORDRQTY
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

    inner join            I_UnitOfMeasure     as e on a.TargetQuantityUnit = e.UnitOfMeasure
{
  key a.SalesContract      as Sales_Cont_No,
      a.SalesContractItem,
      a.Material           as Mat_Code,
      a.TargetQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'TargetQuantityUnit'
      sum(d.OrderQuantity) as Total_Ord_Qty,
      e.UnitOfMeasure_E
}
group by
  a.SalesContract,
  a.SalesContractItem,
  a.Material,
  a.TargetQuantityUnit,
  e.UnitOfMeasure_E
