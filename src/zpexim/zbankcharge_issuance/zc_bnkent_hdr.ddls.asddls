@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Charges Entry'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_BNKENT_HDR
  provider contract transactional_query
  as projection on ZI_BNKENT_HDR
{
      @EndUserText.label: 'ID'
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label:'Document Date'
      Docdate,
      @EndUserText.label:'Posting Date'
      Postingdate,
      @EndUserText.label:'Bank Advice Number'
      Bnkadviceno,

      @EndUserText.label:'Currency'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
      Currency,
      @EndUserText.label:'Bank'
      Bank,
      @EndUserText.label:'Bank Vendor'
      Bankvendor,
      @EndUserText.label:'House Bank'
      Housebank,
      @EndUserText.label:'Account Id'
      Accountid,
      @EndUserText.label:'Tax Codes'
      Taxcode,
      @EndUserText.label:'Invoice Number'
      Invno,
      @EndUserText.label:'Invoice Year'
      Invyear,
      @EndUserText.label:'Amount'
      Tot_Amt,
      @EndUserText.label:'Bank GL Account'
      Bankglacc,
      @EndUserText.label:'Business Place'
      Busiplace,
      @EndUserText.label:'Total Amount with Tax'
      Amountwithtax,
      @EndUserText.label:'Post'
      Tpost,
      @EndUserText.label:'PostUpdate'
      Tpostupd,
      @EndUserText.label:'Account DocNo'
      Belnr,
      @EndUserText.label:'AcDocYear'
      Gjahr,
      @EndUserText.label:'Bank Reference No'
      bankrefno,
      @EndUserText.label:'Ac Post Ref'
      Accpostref,

      /* Associations */
      _item  : redirected to composition child ZC_BNKENT_EXP_I,
      _item1 : redirected to composition child ZC_BNKENT_IMP_I,
      _item2 : redirected to composition child ZC_BNKENT_BG_I
}
