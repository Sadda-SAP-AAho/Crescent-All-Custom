@EndUserText.label: 'Exim Clubbing Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_EXIMCLUBHDR_F4

  as select from ZI_EXIMCLUBHDR

{
      @UI.hidden: true
  key id,
      @EndUserText.label: 'SAP Clubbing No.'
      clubnointernal,
      @EndUserText.label: 'External Clubbing No.'
      clubnoexternal,
      @EndUserText.label: 'Comments'
      clubcomment,
      @EndUserText.label: 'EXIM Doc. Type Desc.'
      documenttypedesc,
      @EndUserText.label: 'Created On'
      cdate,
      @EndUserText.label: 'Created At'
      ctime,
      @EndUserText.label: 'FOB Amount'
      @Semantics.amount.currencyCode: 'fobcurrency'
      fobamount,
      @EndUserText.label: 'FOB Currency'
      fobcurrency
}

where
  released is not initial
