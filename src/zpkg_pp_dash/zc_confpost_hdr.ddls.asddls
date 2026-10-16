@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Conf Post Header'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_CONFPOST_HDR
  provider contract transactional_query
  as projection on ZI_CONFPOST_HDR
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Ref Id'
      Refid,
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
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Created On'
      Creon,
      @EndUserText.label: 'Created by'
      Creby,
      @EndUserText.label: 'Plant Id'
      Plantid,
      @EndUserText.label: 'Shop Floor Date'
      Shpflrdt,
      @EndUserText.label: 'Get Order'
      Getord,
      @EndUserText.label: 'Post'
      Post,
      @EndUserText.label: 'GR'
      Gr,
      @EndUserText.label: 'GI'
      Gi,
      @EndUserText.label: 'Scrap'
      Scrap,
      @EndUserText.label: 'Status'
      Status,
      @EndUserText.label: 'Status for button'
      Stat,
      @EndUserText.label: 'ARPA Charging' 
      Arpacharg,
      @EndUserText.label: 'Rhino Charging'      
      Rhinocharg,
      @EndUserText.label: 'Hand Molding Charging'
      Handmochrg,
      @EndUserText.label: 'Lost Foam Charging'
      Lostfmchrg,
      @EndUserText.label: 'Document Date'
      Docudt,
      @EndUserText.label: 'Unique Id'
      @UI.hidden: true
      uniqueid,
      @EndUserText.label: 'Excessive Weight Adjustment'
      Excwtadj, 
      @EndUserText.label: 'Progress Bar'
      Progress,
      @EndUserText.label: 'Total'
      Total,
      @EndUserText.label: 'Criticality'
      Criticality,
      /* Associations */
      _Item : redirected to composition child ZC_CONFPOST_ITM,
      _Ord  : redirected to composition child ZC_CONFPOST_ORD,
      _Log  : redirected to composition child ZC_CONFPOST_LOG
}
