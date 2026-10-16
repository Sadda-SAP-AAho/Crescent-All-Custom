@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shop Floor Production Dashboard'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_CONF_HDR
  provider contract transactional_query
  as projection on ZI_CONF_HDR

{     
      @EndUserText.label: 'ID'
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Shop Floor Number'
      Shpflrno,
      @EndUserText.label: 'Key'
      Keyid,
      @EndUserText.label: 'Department'
      Dept,
      @EndUserText.label: 'Department Name'
      Deptname,
      @EndUserText.label: 'Operation'
      Opr,
      @EndUserText.label: 'Operation Name'
      Oprname,
      @EndUserText.label: 'Contractor Code'
      Cont,
      @EndUserText.label: 'Contractor Name'
      Contname,
      @EndUserText.label: 'Skilled Labor'
      Skilab,
      @EndUserText.label: 'Semi-Skilled Labor'
      Sskilab,
      @EndUserText.label: 'Un-Skilled Labor'
      Uskilab,
      @EndUserText.label: 'Created On'
      Creon,
      @EndUserText.label: 'Created By'
      Creby,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Plant Key'
      Plantid,
      @EndUserText.label: 'Header'
      Header,
      @EndUserText.label: 'Simulate'
      Simu,
      @EndUserText.label: 'Allocate'
      Alloc,
      @EndUserText.label: 'Scan Barcode'
      Scanbrcode,
      @EndUserText.label: 'Shop Floor Date'
      Shpflrdt,
      @EndUserText.label: 'Generate Serial'
      Genser,           
      @EndUserText.label: 'ARPA Charging' 
      Arpacharg,
      @EndUserText.label: 'Rhino Charging'      
      Rhinocharg,
      @EndUserText.label: 'Hand Molding Charging'
      Handmochrg,
      @EndUserText.label: 'Lost Foam Charging'
      Lostfmchrg,
      @EndUserText.label: 'Excessive Weight Adjustment'
      Excwtadj, 
      /* Associations */
      _Item : redirected to composition child ZC_CONF_ITM,
      _Ord  : redirected to composition child ZC_CONF_ORD

}
