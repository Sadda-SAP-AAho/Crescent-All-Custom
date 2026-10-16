@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Paint BOM Master'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_PAINTBOMMSTR
  provider contract transactional_query
  as projection on ZI_PAINTBOMMSTR
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Micron'
      Micron,
      @EndUserText.label: 'Paint Item Code'
      Paintitmcd,
      @EndUserText.label: 'Paint Item Name'
      Paintitmnm,
      @EndUserText.label: 'Sub Micron'
      Submicron,
      @EndUserText.label: 'Standard Qty'
      Stdqty
}
