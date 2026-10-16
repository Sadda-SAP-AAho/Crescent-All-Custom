@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity View for LC Head'
@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity zi_lchead
  as select from zdt_lchead
  composition [0..*] of zi_lcbank_dlts as _item1
  composition [0..*] of zi_lcimpoi     as _item2
  composition [0..*] of zi_lcbank_ref  as _item3
{
  key zdt_lchead.id                  as Id,
      zdt_lchead.lc_refnr            as Lc_Refnr,
      zdt_lchead.version             as Version,
      zdt_lchead.status              as status,
      case
            when status = 'Created'
            then '2'
            when status = 'Completed'
            then '3'
            else '1'
            end                      as Criticality,
      zdt_lchead.ekorg               as Ekorg,
      zdt_lchead.pur_org_name        as Pur_Org_Name,
      zdt_lchead.lifnr               as Lifnr,
      zdt_lchead.vendor_name         as Vendor_Name,
      zdt_lchead.lc_appl             as Lc_Appl,
      zdt_lchead.lc_number           as Lc_Number,
      zdt_lchead.po                  as Po,
      zdt_lchead.lc_status           as Lc_Status,
      zdt_lchead.lcstatus_name       as Lcstatus_Name,
      zdt_lchead.lc_type             as Lc_Type,
      zdt_lchead.lctyp_name          as Lctyp_Name,
      zdt_lchead.lc_base             as Lc_Base,
      zdt_lchead.div                 as Div,
      zdt_lchead.bank_xblnr          as Bank_Xblnr,
      zdt_lchead.amend_date          as Amend_Date,
      zdt_lchead.amend_txt           as Amend_Txt,
      zdt_lchead.finala              as Finala,
      zdt_lchead.charges             as Charges,
      zdt_lchead.belnr               as Belnr,
      zdt_lchead.zorder              as Zorder,
      zdt_lchead.lc_prof_num         as Lc_Prof_Num,
      zdt_lchead.lc_req_date         as Lc_Req_Date,
      zdt_lchead.lc_open_dt          as Lc_Open_Dt,
      zdt_lchead.lc_exp_date         as Lc_Exp_Date,
      zdt_lchead.lc_appl_name        as Lc_Appl_Name,
      zdt_lchead.lc_benf_name        as Lc_Benf_Name,
      zdt_lchead.lc_prod_date        as Lc_Prod_Date,
      zdt_lchead.lc_purpose          as Lc_Purpose,
      zdt_lchead.lc_creator          as Lc_Creator,
      zdt_lchead.lc_serv_cont_no     as Lc_Serv_Cont_No,
      zdt_lchead.lc_iec_code         as Lc_Iec_Code,
      zdt_lchead.usance              as Usance,
      zdt_lchead.zterm               as Zterm,
      zdt_lchead.payterm_description as Payterm_Description,
      zdt_lchead.ra_vendor           as Ra_Vendor,
      zdt_lchead.tenure              as Tenure,
      zdt_lchead.grace               as Grace,
      zdt_lchead.wkurs               as Wkurs,
      zdt_lchead.waers               as Waers,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_tot_amt_fc       as Lc_Tot_Amt_Fc,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_tot_amt_lc       as Lc_Tot_Amt_Lc,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_add              as Lc_Add,
      zdt_lchead.lc_tolerance        as Lc_Tolerance,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_tol_amt          as Lc_Tol_Amt,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_tot_amt_fc_tol   as Lc_Tot_Amt_Fc_Tol,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_tot_amt_lc_tol   as Lc_Tot_Amt_Lc_Tol,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.interest            as Interest,
      zdt_lchead.lc_buyers_credit    as Lc_Buyers_Credit,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.interest_value      as Interest_Value,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.interest_lc         as Interest_Lc,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_opening          as Lc_Opening,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.swift_charge        as Swift_Charge,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.other_charges       as Other_Charges,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_adj_chrg         as Lc_Adj_Chrg,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_non_tax_chrg     as Lc_Non_Tax_Chrg,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.ammend_charge       as Ammend_Charge,
      zdt_lchead.bank_remarks        as Bank_Remarks,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.bank_rate           as Bank_Rate,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.cgst                as Cgst,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.sgst                as Sgst,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.igst                as Igst,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_shift_char       as Lc_Shift_Char,
      zdt_lchead.commitment_prio     as Commitment_Prio,
      zdt_lchead.bank_lifnr          as Bank_Lifnr,
      zdt_lchead.bank_vendor_name    as Bank_Vendor_Name,
      zdt_lchead.bupla               as Bupla,
      zdt_lchead.secco               as Secco,
      zdt_lchead.mwskz               as Mwskz,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_amend_charge     as Lc_Amend_Charge,
      zdt_lchead.lc_amend_date       as Lc_Amend_Date,
      zdt_lchead.lc_amend_reason     as Lc_Amend_Reason,
      zdt_lchead.partial_shipment    as Partial_Shipment,
      zdt_lchead.prt_ld_cod          as Prt_Ld_Cod,
      zdt_lchead.prt_ds_cod          as Prt_Ds_Cod,
      zdt_lchead.latest_ship_date    as Latest_Ship_Date,
      zdt_lchead.item_detail         as Item_Detail,
      zdt_lchead.cntry_org           as Cntry_Org,
      zdt_lchead.country_name        as Country_Name,
      zdt_lchead.inco1               as Inco1,
      zdt_lchead.inco2               as Inco2,
      zdt_lchead.shipment_mode       as Shipment_Mode,
      zdt_lchead.port_discharge      as Port_Discharge,
      zdt_lchead.port_load           as Port_Load,
      zdt_lchead.transship           as Transship,
      zdt_lchead.insurance_number    as Insurance_Number,
      zdt_lchead.ins_start_date      as Ins_Start_Date,
      zdt_lchead.ins_expiry_date     as Ins_Expiry_Date,
      zdt_lchead.risk_cover_type     as Risk_Cover_Type,
      zdt_lchead.insurace_agent      as Insurace_Agent,
      zdt_lchead.agent_name          as Agent_Name,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.net_lc_amt          as Net_Lc_Amt,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.net_lc_paid_amt     as Net_Lc_Paid_Amt,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_clean_limit      as Lc_Clean_Limit,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.bg_clean_limit      as Bg_Clean_Limit,
      zdt_lchead.fd_customer         as Fd_Customer,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.lc_clean_assign     as Lc_Clean_Assign,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.bg_clean_assign     as Bg_Clean_Assign,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lchead.fd_cust_amt         as Fd_Cust_Amt,
      zdt_lchead.bg_lc_intchng       as Bg_Lc_Intchng,
      zdt_lchead.pay                 as Pay,
      zdt_lchead.create_openlc       as Create_Openlc,
      zdt_lchead.change_lc           as Change_Lc,
      zdt_lchead.create_acamnd       as Create_Acamnd,
      zdt_lchead.display_lc          as Display_Lc,
      zdt_lchead.release_lc          as Release_Lc,
      zdt_lchead.release_revsl       as Release_Revsl,
      zdt_lchead.close_lc            as Close_Lc,
      zdt_lchead.lc_ut_rpt           as Lc_Ut_Rpt,
      zdt_lchead.locallastchangedat  as Locallastchangedat,
      zdt_lchead.amendment as Amendment, 
      zdt_lchead.setout as Setout,
      _item1,
      _item2,
      _item3 // Make association public
}
