@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Bank Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_SUPPLIER_BANK
  provider contract transactional_query
  as projection on I_BusinessPartnerBankTP_3
{
  key BusinessPartner,
  key BankIdentification,
      BankIdnForEditValue,
      BankCountryKey,
      BankName,
      BankNumber,
      SWIFTCode,
      BankControlKey,
      BankAccountHolderName,
      BankAccountName,
      BankValidityStartDate,
      BankValidityEndDate,
      IBAN,
      IBANValidityStartDate,
      BankAccount,
      BankAccountReferenceText,
      CollectionAuthInd,
      BusinessPartnerExternalBankID,
      BPBankDetailsChangeDate,
      BPBankDetailsChangeTargetID,
      BPBankIsProtected,
      CityName,
      AuthorizationGroup,
      DataControllerSet,
      DataController1,
      DataController2,
      DataController3,
      DataController4,
      DataController5,
      DataController6,
      DataController7,
      DataController8,
      DataController9,
      DataController10

}
