@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO Print Header'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_SO_PRINT_HEAD as select from I_SalesDocument

{
     key SalesDocument,
         SalesDocumentDate,
         SalesDocumentType,
         SalesOffice,
         SalesDistrict
         
            
}
