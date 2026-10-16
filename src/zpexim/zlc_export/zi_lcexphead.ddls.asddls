@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For LC Export Header'
define root view entity ZI_LCEXPHEAD
  as select from zdt_lcexphdr
//  association to ZR_CUSTOMER_F4       as _cust on $projection.Lifnr = _cust.Customer
  composition [0..*] of ZI_LCBNK_DLTS as _item1
  composition [0..*] of ZI_LCEXPITM   as _item2
  //    composition [0..*] of ZI_LCBNK_REF  as _item3
{
  key zdt_lcexphdr.id                  as Id,
      zdt_lcexphdr.lc_refnr            as Lc_Refnr,
      zdt_lcexphdr.version             as Version,
      zdt_lcexphdr.status              as Status,
      case
             when status = 'Created'
             then '2'
             when status = 'Completed'
             then '3'
             else '1'
             end                       as Criticality,
      zdt_lcexphdr.companycode         as Companycode,
      zdt_lcexphdr.ekorg               as Ekorg,
      zdt_lcexphdr.companyname         as Companyname,
      zdt_lcexphdr.sales_org_name      as Sales_Org_Name,
      zdt_lcexphdr.lifnr               as Lifnr,
            zdt_lcexphdr.vendor_name         as Vendor_Name,
//      _cust.CustomerName               as Vendor_Name,
      zdt_lcexphdr.lc_appl             as Lc_Appl,
      zdt_lcexphdr.lc_number           as Lc_Number,
      zdt_lcexphdr.so                  as So,
      zdt_lcexphdr.lc_status           as Lc_Status,
      zdt_lcexphdr.lcstatus_name       as Lcstatus_Name,
      zdt_lcexphdr.lc_type             as Lc_Type,
      zdt_lcexphdr.lctyp_name          as Lctyp_Name,
      zdt_lcexphdr.lc_base             as Lc_Base,
      zdt_lcexphdr.div                 as Div,
      zdt_lcexphdr.bank_xblnr          as Bank_Xblnr,
      zdt_lcexphdr.amend_date          as Amend_Date,
      zdt_lcexphdr.amend_txt           as Amend_Txt,
      zdt_lcexphdr.finala              as Finala,
      zdt_lcexphdr.charges             as Charges,
      zdt_lcexphdr.belnr               as Belnr,
      zdt_lcexphdr.zorder              as Zorder,
      zdt_lcexphdr.lc_prof_num         as Lc_Prof_Num,
      zdt_lcexphdr.lc_req_date         as Lc_Req_Date,
      zdt_lcexphdr.lc_open_dt          as Lc_Open_Dt,
      zdt_lcexphdr.lc_exp_date         as Lc_Exp_Date,
      zdt_lcexphdr.lc_appl_name        as Lc_Appl_Name,
      zdt_lcexphdr.lc_benf_name        as Lc_Benf_Name,
      zdt_lcexphdr.lc_prod_date        as Lc_Prod_Date,
      zdt_lcexphdr.lc_purpose          as Lc_Purpose,
      zdt_lcexphdr.lc_creator          as Lc_Creator,
      zdt_lcexphdr.lc_serv_cont_no     as Lc_Serv_Cont_No,
      zdt_lcexphdr.lc_iec_code         as Lc_Iec_Code,
      zdt_lcexphdr.usance              as Usance,
      zdt_lcexphdr.zterm               as Zterm,
      zdt_lcexphdr.payterm_description as Payterm_Description,
      zdt_lcexphdr.ra_vendor           as Ra_Vendor,
      zdt_lcexphdr.tenure              as Tenure,
      zdt_lcexphdr.grace               as Grace,
      zdt_lcexphdr.wkurs               as Wkurs,
      zdt_lcexphdr.waers               as Waers,
      zdt_lcexphdr.currinr             as Currinr,
      @Semantics.amount.currencyCode : 'Currfc'
      zdt_lcexphdr.lc_tot_amt_fc       as Lc_Tot_Amt_Fc,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.lc_tot_amt_lc       as Lc_Tot_Amt_Lc,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.lc_add              as Lc_Add,
      zdt_lcexphdr.lc_tolerance        as Lc_Tolerance,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.lc_tol_amt          as Lc_Tol_Amt,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lcexphdr.lc_tot_amt_fc_tol   as Lc_Tot_Amt_Fc_Tol,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.lc_tot_amt_lc_tol   as Lc_Tot_Amt_Lc_Tol,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.interest            as Interest,
      zdt_lcexphdr.lc_buyers_credit    as Lc_Buyers_Credit,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.interest_value      as Interest_Value,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.interest_lc         as Interest_Lc,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.lc_opening          as Lc_Opening,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.swift_charge        as Swift_Charge,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.other_charges       as Other_Charges,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.lc_adj_chrg         as Lc_Adj_Chrg,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.lc_non_tax_chrg     as Lc_Non_Tax_Chrg,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.ammend_charge       as Ammend_Charge,
      zdt_lcexphdr.bank_remarks        as Bank_Remarks,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.bank_rate           as Bank_Rate,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.cgst                as Cgst,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.sgst                as Sgst,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.igst                as Igst,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.lc_shift_char       as Lc_Shift_Char,
      zdt_lcexphdr.commitment_prio     as Commitment_Prio,
      zdt_lcexphdr.bank_lifnr          as Bank_Lifnr,
      zdt_lcexphdr.bank_vendor_name    as Bank_Vendor_Name,
      zdt_lcexphdr.bupla               as Bupla,
      zdt_lcexphdr.secco               as Secco,
      zdt_lcexphdr.mwskz               as Mwskz,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.lc_amend_charge     as Lc_Amend_Charge,
      zdt_lcexphdr.lc_amend_date       as Lc_Amend_Date,
      zdt_lcexphdr.lc_amend_reason     as Lc_Amend_Reason,
      zdt_lcexphdr.partial_shipment    as Partial_Shipment,
      zdt_lcexphdr.prt_ld_cod          as Prt_Ld_Cod,
      zdt_lcexphdr.prt_ds_cod          as Prt_Ds_Cod,
      zdt_lcexphdr.latest_ship_date    as Latest_Ship_Date,
      zdt_lcexphdr.item_detail         as Item_Detail,
      zdt_lcexphdr.cntry_org           as Cntry_Org,
      zdt_lcexphdr.country_name        as Country_Name,
      zdt_lcexphdr.inco1               as Inco1,
      zdt_lcexphdr.inco2               as Inco2,
      zdt_lcexphdr.shipment_mode       as Shipment_Mode,
      zdt_lcexphdr.port_discharge      as Port_Discharge,
      zdt_lcexphdr.port_load           as Port_Load,
      zdt_lcexphdr.transship           as Transship,
      zdt_lcexphdr.insurance_number    as Insurance_Number,
      zdt_lcexphdr.ins_start_date      as Ins_Start_Date,
      zdt_lcexphdr.ins_expiry_date     as Ins_Expiry_Date,
      zdt_lcexphdr.risk_cover_type     as Risk_Cover_Type,
      zdt_lcexphdr.insurace_agent      as Insurace_Agent,
      zdt_lcexphdr.agent_name          as Agent_Name,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.net_lc_amt          as Net_Lc_Amt,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.net_lc_paid_amt     as Net_Lc_Paid_Amt,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.lc_clean_limit      as Lc_Clean_Limit,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.bg_clean_limit      as Bg_Clean_Limit,
      zdt_lcexphdr.fd_customer         as Fd_Customer,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.lc_clean_assign     as Lc_Clean_Assign,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.bg_clean_assign     as Bg_Clean_Assign,
      @Semantics.amount.currencyCode : 'CURRINR'
      zdt_lcexphdr.fd_cust_amt         as Fd_Cust_Amt,
      zdt_lcexphdr.bg_lc_intchng       as Bg_Lc_Intchng,
      zdt_lcexphdr.pay                 as Pay,
      zdt_lcexphdr.create_openlc       as Create_Openlc,
      zdt_lcexphdr.change_lc           as Change_Lc,
      zdt_lcexphdr.create_acamnd       as Create_Acamnd,
      zdt_lcexphdr.display_lc          as Display_Lc,
      zdt_lcexphdr.release_lc          as Release_Lc,
      zdt_lcexphdr.release_revsl       as Release_Revsl,
      zdt_lcexphdr.close_lc            as Close_Lc,
      zdt_lcexphdr.lc_ut_rpt           as Lc_Ut_Rpt,
      zdt_lcexphdr.locallastchangedat  as Locallastchangedat,
      zdt_lcexphdr.amendment           as Amendment,
      zdt_lcexphdr.setout              as Setout,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lcexphdr.avail_amount        as Avail_Amount,
      zdt_lcexphdr.currfc              as Currfc,


//      _cust,
      _item1,
      _item2
      //     _item3
}
