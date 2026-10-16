@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR BARODA ITEM DETAILS'
@Metadata.allowExtensions: true
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #XXL,
    dataClass: #TRANSACTIONAL
}
define view entity ZC_DPR_BARD_ITM
  as projection on ZI_DPR_BARD_ITM
{
      @EndUserText.label: 'Plant'
      @Search.defaultSearchElement: true
  key Plant,
      @EndUserText.label: 'Dept'
      //    @Search.defaultSearchElement: true
  key Kostl,
      @EndUserText.label: 'Dept'
      @Search.defaultSearchElement: true
  key Kostl1,
      @EndUserText.label: 'Report Date'
      @Search.defaultSearchElement: true
      // @UI.hidden: true
  key Indate,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Day/Month/Yr'
  key Mtdytd,
      @EndUserText.label: 'Report Date'
      Vdate,
      @EndUserText.label: 'Prodn_Plan_Qty'
      Prodplanqty,
      @EndUserText.label: 'Total_Poured'
      Totalpoured,
      @EndUserText.label: 'Mc_Loss'
      Mcloss,
      @EndUserText.label: 'Total_Cast'
      Totalcast,
      @EndUserText.label: 'Pending_Cast'
      Pendcast,
      @EndUserText.label: 'Std_Good_Cast_Wt'
      Stdgoodcast,
      @EndUserText.label: 'Actual_Good_Cast_Wt'
      Actgoodcast,
      @EndUserText.label: 'Total_Good_Mould'
      Totgoodmould,
      @EndUserText.label: 'Total_Bad_Mould'
      Totbadmould,
      @EndUserText.label: 'Bunch_wt'
      Bunchwt,
      @EndUserText.label: 'Bunch_wt_FAR'
      Bunchwtfar,
      @EndUserText.label: 'Rej_Wt'
      Rejwt,
      @EndUserText.label: 'Second_Line_Rej'
      Seclinerej,
      @EndUserText.label: 'Rej_Percentage'
      Rejper,
      @EndUserText.label: 'Final_Rej_Per'
      Finalrejper,
      @EndUserText.label: 'Rej_Loss Value'
      Rejlossval,
      @EndUserText.label: 'Excess_Wt'
      Excesswt,
      @EndUserText.label: 'Pack_Wt'
      Packwt,
      @EndUserText.label: 'Desp_Wt'
      Despwt,
      @EndUserText.label: 'Ontime_Desp_Qty'
      Ontimdespqty,
      @EndUserText.label: 'Ontime_Desp_Wt'
      Ontimdespwt,
      @EndUserText.label: 'Charging_OPRN'
      Chargoprn,
      @EndUserText.label: 'Spillage'
      Spillage,
      @EndUserText.label: 'StdYield'
      Stdyield,
      @EndUserText.label: 'StdYield_FAR'
      Stdyieldfar,
      @EndUserText.label: 'Yield'
      Yield,
      @EndUserText.label: 'Yield_FAR'
      Yieldfar,
      @EndUserText.label: 'STD_LM_COST'
      Stdlmcost,
      @EndUserText.label: 'LM_Cost'
      Lmcost,
      @EndUserText.label: 'STD_LM_COST_CI'
      Stdlmcicost,
      @EndUserText.label: 'LM_Cost_CI'
      Lmcostci,
      @EndUserText.label: 'FG_Stock'
      Fgstock,
      @EndUserText.label: 'SFG_Stock'
      Sfgstock,
      @EndUserText.label: 'RM_Stock'
      Rmstock,
      @EndUserText.label: 'LM_Stock'
      Lmstock,
      @EndUserText.label: 'CASTING_Stock'
      Caststock,
      @EndUserText.label: 'MACHINING_Stock'
      Macstock,
      @EndUserText.label: 'GRINDING_Stock'
      Grindstock,
      @EndUserText.label: 'PAINTING_Stock'
      Paintstock,
      @EndUserText.label: 'NoOfComplaints'
      Noofcompl,
      @EndUserText.label: 'CmptAmt'
      Complamt,
      @EndUserText.label: 'StoreCost_Std_GI'
      Stcoststdgi,
      @EndUserText.label: 'StoreCost_AcualExpense'
      Stcostactexp,
      @EndUserText.label: 'StoreCost_Mould_Std_GI'
      Stcostmoustd,
      @EndUserText.label: 'StoreCost_Mould_AcualExpense'
      Stcostmouact,
      @EndUserText.label: 'StoreCost_Melt_Std_GI'
      Stcostmeltstd,
      @EndUserText.label: 'StoreCost_Melt_AcualExpense'
      Stcostmeltact,
      @EndUserText.label: 'StoreCost_Other_Std_GI'
      Stcostothstd,
      @EndUserText.label: 'StoreCost_Other_AcualExpense'
      Stcostothacc,
      @EndUserText.label: 'DItreatmentCost_Std_GI'
      Trtmntcoststd,
      @EndUserText.label: 'DItreatmentCost_AcualExpense'
      Trtmntcostacc,
      @EndUserText.label: 'Power_Cost_Std_GI'
      Powercoststd,
      @EndUserText.label: 'Power_cost_actual'
      Powercostact,
      @EndUserText.label: 'Std_power_unit'
      Stdpowerunit,
      @EndUserText.label: 'Actual_power_unit_Aux'
      Actpowunitaux,
      @EndUserText.label: 'Actual_power_unit_Fur'
      Actpoeunitfur,
      @EndUserText.label: 'Fixed_Cost_Loss'
      Fixedcostloss,
      @EndUserText.label: 'Std_Labour_Exp'
      Stdlabexp,
      @EndUserText.label: 'Act_Labour_Exp'
      Actlabexp,
      @EndUserText.label: 'Productivity'
      Productivity,
      @EndUserText.label: 'OITF'
      Otif,
      /* Associations */
      _head : redirected to parent ZC_DPR_BARD_HEAD


}
