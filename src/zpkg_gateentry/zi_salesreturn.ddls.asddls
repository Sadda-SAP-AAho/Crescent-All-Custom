@AbapCatalog.sqlViewName: 'ZSALESRETURN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sales return'
define view zi_salesreturn as select from I_SalesDocument  as A 
left outer join I_SalesDocumentItem as B on
B.SalesDocument = A.SalesDocument
left outer join I_SDDocumentMultiLevelProcFlow as c on
c.PrecedingDocument = B.SalesDocument

{
    key c.DocRelationshipUUID,
    key A.SalesDocument,
    c.SubsequentDocumentItem,
    c.SubsequentDocumentCategory
}
where c.SubsequentDocumentCategory = 'T'
