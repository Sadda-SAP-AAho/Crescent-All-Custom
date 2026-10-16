@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-Open Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MGMTOPNORDR
  as select from ZI_MGMTOPNORDRCI
{
  key Plant,
  key ProfitCenter,
      Balance_Wt  as Open_Order_WT,
      Balance_Val as Open_Order_Val
}

union

select from ZI_MGMTOPNORDRDI
{
  key Plant,
  key ProfitCenter,
      Balance_Wt  as Open_Order_WT,
      Balance_Val as Open_Order_Val
}

union

select from ZI_MGMTOPNORDRMS
{
  key Plant,
  key ProfitCenter,
      Balance_Wt  as Open_Order_WT,
      Balance_Val as Open_Order_Val
}

union

select from ZI_MGMTOPNORDRSALOTH
{
  key Plant,
  key ProfitCenter,
      Balance_Wt  as Open_Order_WT,
      Balance_Val as Open_Order_Val
}

union

select from ZI_MGMTOPNORDRNONSALP
{
  key Plant,
  key ProfitCenter,
      Balance_Wt  as Open_Order_WT,
      Balance_Val as Open_Order_Val
}

union

select from ZI_MGMTOPNORDRKUL
{
  key Plant,
  key ProfitCenter,
      Balance_Wt  as Open_Order_WT,
      Balance_Val as Open_Order_Val
}

union

select from ZI_MGMTOPNORDRNONKUL
{
  key Plant,
  key ProfitCenter,
      Balance_Wt  as Open_Order_WT,
      Balance_Val as Open_Order_Val
}

union

select from ZI_MGMTOPNORDRBAG
{
  key Plant,
  key ProfitCenter,
      Balance_Wt  as Open_Order_WT,
      Balance_Val as Open_Order_Val
}

union

select from ZI_MGMTOPNORDRNONBAG
{
  key Plant,
  key ProfitCenter,
      Balance_Wt  as Open_Order_WT,
      Balance_Val as Open_Order_Val
}

union

select from ZI_MGMTOPNORDRSINTO
{
  key Plant,
  key ProfitCenter,
      Balance_Wt  as Open_Order_WT,
      Balance_Val as Open_Order_Val
}

union

select from ZI_MGMTOPNORDRLF
{
  key Plant,
  key ProfitCenter,
      Balance_Wt  as Open_Order_WT,
      Balance_Val as Open_Order_Val
}

union

select from ZI_MGMTOPNORDRNONBAR
{
  key Plant,
  key ProfitCenter,
      Balance_Wt  as Open_Order_WT,
      Balance_Val as Open_Order_Val
}
