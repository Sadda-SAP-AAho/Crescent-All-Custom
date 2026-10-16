@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order wise Bulk Order Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SOWISEBODETAILS
  as select distinct from ZI_SALESREGSHRT     as a
    inner join            I_SalesDocument     as b on a.SalesOrderNumber = b.SalesDocument
    inner join            I_SalesDocumentItem as c on  b.SalesDocument  = c.SalesDocument
                                                   and a.SalesOrderItem = c.SalesDocumentItem
    left outer join       I_SalesContractItem as d on  b.ReferenceSDDocument     = d.SalesContract
                                                   and c.ReferenceSDDocumentItem = d.SalesContractItem
    left outer join       I_SalesContract     as e on d.SalesContract = e.SalesContract
    left outer join       I_SalesDocument     as f on f.SalesDocument = e.SalesContract
{
  key a.SalesOrderNumber,
  key a.SalesOrderDate,
  key a.SalesOrderItem,
  key d.SalesContract,
  key e.SalesContractDate,
  key f.YY1_POEntryMailRecdDat_SDH,
  key d.SalesContractItem

}
