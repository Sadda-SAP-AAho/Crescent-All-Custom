@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Supplier Payment Request'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_SUPP_PAY_REQ
  as select from zdt_supp_pay_req
{
  key id              as Id,
      keyid           as Keyid,
      fisyear         as fisyear,
      creon           as Creon,
      doc_num         as DocNum,
      doc_date        as DocDate,
      created_by      as CreatedBy,
      created_by_name as CreatedByName,
      vendor_code     as VendorCode,
      vendor_name     as VendorName,
      payment_amount  as PaymentAmount
}
