@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For OC Form Header'
define root view entity ZI_OCFORM_Header
  as select from    I_SalesOrder       as a
    left outer join ZI_FINAL_DEST      as b on a.YY1_FinalDestination_SDH = b.value_low
    left outer join I_PaymentTermsText as c on  a.CustomerPaymentTerms = c.PaymentTerms
                                            and c.Language             = 'E'



{
  key  a.SalesOrder                         as OrdNo,
       a.CreationDate                       as Dt,
       a.YY1_SD_SORD_BPNAME_SDH             as BillNm,
       a.YY1_SD_SORD_BPNAME_SDH             as ShpNm,
       upper( a.YY1_SD_SORD_BPADDRESS_SDH ) as BillAdd,
       upper( a.YY1_SD_SORD_BPADDRESS_SDH ) as ShpAdd,
       a.TransactionCurrency                as OrdCurrency,
       a.YY1_SD_SORD_POD_SDH                as POD,
       a.IncotermsClassification            as ShippTyp,
       b.text                               as FnlDst,
       c.PaymentTermsDescription            as PaymentTerms,
       a.YY1_PlannedMonth_Ship_SDH          as PlndMnthShipment,
       cast('' as abap.char(1))             as printflag,
       cast('' as abap.char(1))             as flag
}
