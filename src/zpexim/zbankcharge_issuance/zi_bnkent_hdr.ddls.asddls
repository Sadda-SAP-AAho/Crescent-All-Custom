@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for bank entry header'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define root view entity ZI_BNKENT_HDR
  as select from zdt_bnk_ent_hdr
  composition [0..*] of ZI_BNKENT_EXP_I as _item
  composition [0..*] of ZI_BNKENT_IMP_I as _item1
  composition [0..*] of ZI_BNKENT_BG_I  as _item2

{
  key zdt_bnk_ent_hdr.id            as Id,
      zdt_bnk_ent_hdr.docdate       as Docdate,
      zdt_bnk_ent_hdr.postingdate   as Postingdate,
      zdt_bnk_ent_hdr.bnkadviceno   as Bnkadviceno,
      zdt_bnk_ent_hdr.currency      as Currency,
      zdt_bnk_ent_hdr.bank          as Bank,
      zdt_bnk_ent_hdr.bankvendor    as Bankvendor,
      zdt_bnk_ent_hdr.housebank     as Housebank,
      zdt_bnk_ent_hdr.accountid     as Accountid,
      zdt_bnk_ent_hdr.taxcode       as Taxcode,
      zdt_bnk_ent_hdr.invno         as Invno,
      zdt_bnk_ent_hdr.invyear       as Invyear,
      @Semantics.amount.currencyCode: 'currency'
      zdt_bnk_ent_hdr.tot_amt       as Tot_Amt,
      zdt_bnk_ent_hdr.bankglacc     as Bankglacc,
      zdt_bnk_ent_hdr.busiplace     as Busiplace,
      @Semantics.amount.currencyCode: 'currency'
      zdt_bnk_ent_hdr.amountwithtax as Amountwithtax,
      zdt_bnk_ent_hdr.tpost         as Tpost,
      zdt_bnk_ent_hdr.tpost         as Tpostupd,
      zdt_bnk_ent_hdr.belnr         as Belnr,
      zdt_bnk_ent_hdr.gjahr         as Gjahr,
      zdt_bnk_ent_hdr.bankrefno     as bankrefno,
      zdt_bnk_ent_hdr.accpostref    as Accpostref,


      _item,
      _item1,
      _item2
}
