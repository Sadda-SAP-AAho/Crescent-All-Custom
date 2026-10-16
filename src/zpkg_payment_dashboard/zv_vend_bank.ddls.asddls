@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vender Bank Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_VEND_BANK
  as select from I_BusinessPartnerBank as a
    inner join   I_Supplier            as b on a.BusinessPartner = b.Supplier
    inner join   ZV_VEND_BANK_1        as c on  a.BusinessPartner    = c.BusinessPartner
                                            and a.BankIdentification = c.BankIdentification
{
  key a.BusinessPartner,
  key a.BankIdentification,
      a.BankCountryKey,
      a.BankName,
      a.BankNumber,
      a.SWIFTCode,
      a.BankControlKey,
      a.BankAccountHolderName,
      a.BankAccountName,
      a.ValidityStartDate,
      a.ValidityEndDate,
      a.IsActualDate,
      a.BPIsActualDate,
      a.IBAN,
      a.IBANValidityStartDate,
      a.BankAccount,
      a.BankAccountReferenceText,
      a.CollectionAuthInd,
      a.BusinessPartnerExternalBankID,
      a.BPBankDetailsChangeDate,
      a.BPBankDetailsChangeTargetID,
      a.BPBankIsProtected,
      a.BPBankUUID,
      a.CityName


}
//where
//  a.BankIdentification = '0001'
