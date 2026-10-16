@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View of Rework Register- Item'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_REWORKREGITM
  as projection on ZI_REWORKREGITM
{
  key id,
  key item,
      @EndUserText.label: 'Report Date'
      rptdate,
      @EndUserText.label: 'Material Code'
      matcd,
      @EndUserText.label: 'Material Name'
      matnm,
      @EndUserText.label: 'Quantity'
      quantity,
      @EndUserText.label: 'Resource Name'
      resource_name,
      @EndUserText.label: 'Work Details'
      workdetls,
      @EndUserText.label: 'Work Minutes'
      workmin,
      @EndUserText.label: 'Total Cost'
      totalcost,
      /* Associations */
      _Head : redirected to parent ZC_REWORKREGHED
}
