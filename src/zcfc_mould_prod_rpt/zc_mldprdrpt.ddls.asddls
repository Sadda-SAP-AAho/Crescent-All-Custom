@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view of Mould Prod Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_MLDPRDRPT
  provider contract transactional_query
  as projection on ZI_MLDPRDRPT

{
    @UI.hidden: true
    key ID,
    @UI.hidden: true
    key Item,
    @EndUserText.label: 'Production Date'
    prddate,
    @EndUserText.label: 'Plant Code'
    plntcd,
    @EndUserText.label: 'Plant Name'
    plntnm,
    @EndUserText.label: 'Cost Centre Code'
    cstcntr,
    @EndUserText.label: 'Cost Centre Name'
    cstcntrnm,
    @EndUserText.label: 'Profit Centre'
    prftcntr,
    @EndUserText.label: 'Profit Centre Name'
    prftcntrnm,
    @EndUserText.label: 'Type of Mould'
    typeofmould,
    @EndUserText.label: 'Quantity'
    Qty,
    @EndUserText.label: 'Remarks'
    Remarks,
    @EndUserText.label: 'Extra 1'
    Extra1,
    @EndUserText.label: 'Extra 2'
    Extra2
}
