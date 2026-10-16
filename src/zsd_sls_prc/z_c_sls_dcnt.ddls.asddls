@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Sales Discount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X, 
    sizeCategory: #S,     
    dataClass: #MIXED     
}


@Metadata.allowExtensions: true


define root view entity Z_C_SLS_DCNT
  provider contract transactional_query
  as projection on Z_I_SLS_DCNT
{

  key     SalesDocument,                  
  key     So_line_no,                    


          Sales_Order_Date,               
          Customer_Po_No,                 
          Customer_Po_date,                

          @Consumption.filter.selectionType: #RANGE
          Cust_Reqd_Dt,                  

          @Semantics.currencyCode: true
          Currency,                       

          Salesorg,                      

          @Consumption.filter.selectionType: #SINGLE
          Customer,                        

          Distchan,                        

 
          PO_Line_No,
          Material,                     
          Material_Description,   
          Material_Sub_Code,        
          Unit,                           

          @Semantics.quantity.unitOfMeasure: 'Unit'
          Order_Quantity,                 

        
          STD_Unit_Wt,                     
          Total_Weight,                   

   
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_UNIT_PRICE'
          @EndUserText.label: 'as per Price List-on CRD'
          @Semantics.amount.currencyCode: 'Currency'
  virtual Unitprice   : abap.curr( 13,2 ), 
          Total_Wt_Mt,                   

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_UNIT_PRICE'
          @EndUserText.label: 'Total Price'
          @Semantics.amount.currencyCode: 'Currency'
  virtual Total_price : abap.curr( 13,2 ),

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_UNIT_PRICE'
          @EndUserText.label: 'Value MT'
          @Semantics.amount.currencyCode: 'Currency'
  virtual Value_Mt    : abap.curr( 13,2 ), 
  
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_UNIT_PRICE'
          @EndUserText.label: 'Discount %'
          @Semantics.quantity.unitOfMeasure: 'DiscountUnit'
  virtual Discount_percent    : abap.dec(5,2)  ,
  
  @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_UNIT_PRICE'
          @EndUserText.label: 'Discount %'
          @Semantics.quantity.unitOfMeasure: 'DiscountUnit'
  virtual Discount_per    : abap.dec(5,2)  ,
  
  @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_UNIT_PRICE'
  @Semantics.unitOfMeasure: true

virtual DiscountUnit : abap.unit( 3 ),

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_UNIT_PRICE'
          @EndUserText.label: 'Discount'
          @Semantics.amount.currencyCode: 'Currency'
  virtual Discount    : abap.curr( 13,2 ) ,
  
            @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_UNIT_PRICE'
          @EndUserText.label: 'Grand Total Price'
          @Semantics.amount.currencyCode: 'Currency'
  virtual Grand_Total_price : abap.curr( 13,2 ) ,
  
              @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_UNIT_PRICE'
          @EndUserText.label: 'Grand Total Wt'
  virtual Grand_Total_wt : abap.curr( 13,2 ) 
};
