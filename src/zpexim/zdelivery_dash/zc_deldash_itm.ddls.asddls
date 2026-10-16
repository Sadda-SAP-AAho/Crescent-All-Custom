@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Delivery Dash Item'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_DELDASH_ITM
  as projection on ZI_DELDASH_ITM
{
      @EndUserText.label: 'Id'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Delivery'
      Delivery,
      @EndUserText.label: 'Line Number'
      Posnr,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Storage Location'
      Lgort,
      @EndUserText.label: 'Material Code'
      Matnr,
      @EndUserText.label: 'Material Description'
      Maktx,
      @EndUserText.label: 'UOM'
      Meins,
      @EndUserText.label: 'Quatity'
      Qty,
      @EndUserText.label: 'Customer Required Date'
      Cusreqdt,
      @EndUserText.label: 'Revision No'
      Revno,
      @EndUserText.label: 'OITF Dt'
      Oitfdt,
      @EndUserText.label: 'Item Paint Information'
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PROD_TEXT'
      Itmpaiinfo,
      @EndUserText.label: 'HSN of Material'
      Hsn,
      @EndUserText.label: 'Net Weight of Material'
      Nwt,
      @EndUserText.label: 'Gross Weight of Material'
      Gwt,
      @EndUserText.label: 'Unit'
      Unit,
      
      /* Associations */
      _Head : redirected to parent ZC_DELDASH_HDR
}
