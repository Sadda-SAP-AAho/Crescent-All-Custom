@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contractor Wise Production Report Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #XXL,
    dataClass: #TRANSACTIONAL
}

define root view entity ZC_CONTRACT_HDR
    as projection on ZI_CONTRACT_HDR

{
      @EndUserText.label: 'Operation No.'
  key Opr,
      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'Department'
  key Dept,
      @EndUserText.label: 'Contractor'
  key Cont,
      @EndUserText.label: 'Posting Date'
      Shpflrdt,
      @EndUserText.label: 'Department Name'
      Deptname,
      @EndUserText.label: 'Operation Name'
      Oprname,
      @EndUserText.label: 'Contractor Name'
      Contname,
      @EndUserText.label: 'Labour Item No. 1'
      laboritemno1,
      @EndUserText.label: 'Labour Item No. 2'
      laboritemno2,
      @EndUserText.label: 'Labour Item No. 3'
      laboritemno3,
      @EndUserText.label: 'Labour Item No. 4'
      laboritemno4,
      @EndUserText.label: 'Print Report'
      Printrep,
      Updateprint,
      /* Associations */
     _item  : redirected to composition child ZC_CONTRACT_ITM

}
