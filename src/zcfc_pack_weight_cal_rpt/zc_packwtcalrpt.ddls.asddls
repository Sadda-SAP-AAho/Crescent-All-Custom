@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pack Weight Calculation Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define root view entity ZC_PACKWTCALRPT
  provider contract transactional_query
  as projection on ZI_PACKWTCALRPT
{
      @EndUserText.label: 'Delivery Number'
      @Search.defaultSearchElement: true
  key Delivery,

      @EndUserText.label: 'Delivery Item'
      @Search.defaultSearchElement: true
  key DelItem,

      @EndUserText.label: 'Plant'
      @Search.defaultSearchElement: true
      Plant,
      
      @EndUserText.label: 'Customer Code'
      @Search.defaultSearchElement: true
      CustCode,

      @EndUserText.label: 'Material'
      @Search.defaultSearchElement: true
      Material,

      @EndUserText.label: 'Description'
      Descrption,

      @EndUserText.label: 'UOM'
      Uom,

      @EndUserText.label: 'Material Net Wt'
      Matnetwt,

      @EndUserText.label: 'Weight UOM'
      Wtunit,

      @EndUserText.label: 'Pack Material'
      Packmat,
      
      @EndUserText.label: 'Pack Material Group'
      PackMtlGrp,

      @EndUserText.label: 'Pack Material Type'
      Packmattyp,

      @EndUserText.label: 'No. of Packages'
      NoOfPack,

      @EndUserText.label: 'Package Wt'
      PackWt,

      @EndUserText.label: 'Priority'
      Priority,

      @EndUserText.label: 'PackWt-Calculated'
      PackWtCal,

      @EndUserText.label: 'Material in Each Package'
      Mateachpkg,

      @EndUserText.label: 'Delivery Qty'
      DelQty,

      @EndUserText.label: 'Each Pkg Net Wt'
      EachPackNetWt,

      @EndUserText.label: 'Each Pkg Gross Wt'
      EachPackGroWt,

      @EndUserText.label: 'Net Weight'
      Netwt,

      @EndUserText.label: 'Gross Weight'
      Growt,
      
      @EndUserText.label: 'Net Weight-Weighbridge'
      NetwtWb,

      @EndUserText.label: 'BOM Pack Qty'
      BomPackQty
}
