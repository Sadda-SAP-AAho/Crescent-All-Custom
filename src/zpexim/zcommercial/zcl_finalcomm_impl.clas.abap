CLASS zcl_finalcomm_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FINALCOMM_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'BILLINGDOCUMENT' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    DATA : lt_return TYPE TABLE OF zcus_finalcomm.
data : customfreight type p DECIMALS 2.
data : freightval type string.
data : line_amount type string.
data : line_total type string.
data : total_price type string.
data : grand_total type p DECIMALS 2.
data : lv_disc type p DECIMALS 2.
data : line_tot type p DECIMALS 2.

    LOOP AT lt_range[ name = 'BILLINGDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_bill) = <ls_range>-low.
      lv_bill = |{ lv_bill ALPHA = IN }|.
      SELECT SINGLE * FROM zcds_finalcommhed
      WHERE billingdocument = @lv_bill
      INTO @DATA(ls_bill1).


      SELECT SINGLE * FROM zcds_amtcomm1
    WHERE billingdocument = @lv_bill
    INTO @DATA(ls_amt).

      SELECT SINGLE * FROM zcds_amtcomm
     WHERE billingdocument = @lv_bill
     INTO @DATA(ls_amt1).


      DATA: lv_paise TYPE string.
      DATA: lv_rupees TYPE string .
      DATA: lv_amtwrd TYPE string.
      DATA: amtintext TYPE char256.
      lv_rupees = ls_amt-totalamt.
      lv_amtwrd = zcl_numtowords=>znumword( EXPORTING iv_num = lv_rupees
                                 CHANGING rv_dec_words = lv_paise ).

      CONCATENATE lv_amtwrd
                  'Rupees and'
        INTO     amtintext
        SEPARATED BY space.

      CONCATENATE amtintext
                  lv_paise
                  'Paise Only'
        INTO      amtintext
        SEPARATED BY space.

      DATA lv_bill1 TYPE vbeln.

      lv_bill1 = |{ lv_bill ALPHA = IN }|.

      DATA: lv_custinv TYPE string.

      SELECT * FROM i_billingdocumentitem
      WITH PRIVILEGED ACCESS
      WHERE billingdocument =  @lv_bill1
      INTO TABLE @DATA(lt_billingdoc).



select single flag from zdt_comm_hed where commid = @lv_bill into @data(flag).
if flag = 'F'.
      select single custfrght  from zdt_finlpack_hdr where comm_inv = @lv_bill into @customfreight.
freightval = customfreight.
CONDENSE freightval.
select single  * from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem eq '000000' into @data(gs_col).

if gs_col-col1 = 'AMOUNT'.
select col1 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @data(lt_line_total).
elseif gs_col-col2 = 'AMOUNT'.
select col2 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
elseif gs_col-col3 = 'AMOUNT'.
select col3 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
elseif gs_col-col4 = 'AMOUNT'.
select col4 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
elseif gs_col-col5 = 'AMOUNT'.
select col5 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
elseif gs_col-col6 = 'AMOUNT'.
select col6 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
elseif gs_col-col7 = 'AMOUNT'.
select col7 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
elseif gs_col-col8 = 'AMOUNT'.
select col8 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
elseif gs_col-col9 = 'AMOUNT'.
select col9 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
elseif gs_col-col10 = 'AMOUNT'.
select col10 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
elseif gs_col-col11 = 'AMOUNT'.
select col11 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
elseif gs_col-col12 = 'AMOUNT'.
select col12 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
elseif gs_col-col13 = 'AMOUNT'.
select col13 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
elseif gs_col-col14 = 'AMOUNT'.
select col14 from zdt_item_data where billingdocument = @lv_bill and  billingdocumentitem ne '000000' into table @lt_line_total.
ENDIF.

loop at lt_line_total into data(ls_line_total).
total_price = total_price + ls_line_total.
endloop.
CONDENSE total_price.
elseif flag = 'S'.
     select single custfrght  from zdt_finlpack_hdr where comm_inv = @lv_bill into @customfreight.
freightval = customfreight.
CONDENSE freightval.
select col19 from zdt_item_data where billingdocument = @lv_bill into table @lt_line_total.

loop at lt_line_total into ls_line_total.
total_price = total_price + ls_line_total.
endloop.
CONDENSE total_price.
endif.

      DELETE ADJACENT DUPLICATES FROM lt_billingdoc COMPARING referencesddocument.


      SELECT * FROM i_billingdocumentitem
      WITH PRIVILEGED ACCESS FOR ALL ENTRIES IN @lt_billingdoc
      WHERE referencesddocument = @lt_billingdoc-referencesddocument
      INTO TABLE @DATA(lt_billingdoc1).

      DELETE ADJACENT DUPLICATES FROM lt_billingdoc1 COMPARING billingdocument.


      SELECT documentreferenceid FROM i_billingdocument
      WITH PRIVILEGED ACCESS FOR ALL ENTRIES IN @lt_billingdoc1
      WHERE billingdocument = @lt_billingdoc1-billingdocument
      AND billingdocument <> @lv_bill1
      AND accountingtransferstatus <> 'E'
      AND billingdocumenttype = 'F8'
      INTO TABLE @DATA(lt_custinvs).

      LOOP AT lt_custinvs INTO DATA(lv_custinvs).

        IF sy-subrc IS INITIAL.

          CONCATENATE lv_custinvs
                      ','
                      lv_custinv
             INTO     lv_custinv
             SEPARATED BY space.

        ENDIF.

      ENDLOOP.


if freightval is INITIAL.

      INSERT VALUE zcus_finalcomm(
      billingdocument = lv_bill
      creationdate    = ls_bill1-creationdate
      caddress1       = ls_bill1-caddress1
      caddress2       = ls_bill1-caddress2
      name            = ls_bill1-name
      carsealno       = ls_bill1-carsealno
      findes          = ls_bill1-findes
      purchaseorderbycustomer = ls_bill1-purchaseorderbycustomer
      cinno           = ls_bill1-cinno
      cod             = ls_bill1-cod
      contno          = ls_bill1-contno
      coo             = ls_bill1-coo
      gstin           = ls_bill1-gstin
      iec             = ls_bill1-iec
      pol              = ls_bill1-pol
      pod              = ls_bill1-pod
      cusmar           = ls_bill1-cusmar
      descgoods        = ls_bill1-descgoods
      precarby         = ls_bill1-precarby
      por              = ls_bill1-por
      vesselno         = ls_bill1-vesselcode
      sumgrosswt       = ls_bill1-sumgrosswt
      sumnetwt         = ls_bill1-sumnetwt
      shippingbill     = ls_bill1-shippingbill
      descgoods1       = ls_bill1-descgoods1
      descgoods2       = ls_bill1-descgoods2
      var3             = ls_bill1-var3
      remarks1         = ls_bill1-remarks1
      remarks2         = ls_bill1-remarks2
      amtintext        = amtintext
      discval          = ls_amt1-discsum
      freightval       =  ''                              "ls_amt1-freightsum
      packingval       = ls_amt1-packingsum
      totalamt         = ls_amt-totalamt
      bankname         = ls_bill1-bankname
      streetname       = ls_bill1-streetname
      cityname         = ls_bill1-cityname
      counconsignee    = ls_bill1-counconsignee
      counbuyer        = ls_bill1-counbuyer
      custbuyer        = ls_bill1-custbuyer
      custconsignee    = ls_bill1-custconsignee
      amtsum           = ls_amt1-sumamount + ls_amt1-freightsum + ls_amt1-packingsum
      netduedate       = ls_bill1-netduedate
      transactioncurrency = ls_bill1-transactioncurrency
      customerpaymenttermsname = ls_bill1-customerpaymenttermsname
      incotermsclassificationname = ls_bill1-incotermsclassificationname
      ladingno          = ls_bill1-ladingno
      proinv            = lv_custinv "ls_bill1-proinv "ls_billingDoc-DocumentReferenceID
      ladingdt          = ls_bill1-ladingdt
      salesnoteref      = ls_bill1-salesnoteref
      ) INTO TABLE lt_return.

 elseif freightval is NOT INITIAL.
 if flag = 'S'.
   line_Amount = total_price.
 CONDENSE line_amount.
 IF ls_amt1-discsum < 0.
  lv_disc = abs( ls_amt1-discsum ).
ENDIF.
grand_total = ( line_amount - lv_disc ) + freightval.
 else.
    line_Amount = total_price.
 CONDENSE line_amount.
 IF ls_amt1-discsum < 0.
  lv_disc = abs( ls_amt1-discsum ).
ENDIF.
grand_total = ( line_amount - lv_disc ) + freightval.
 endif.

       INSERT VALUE zcus_finalcomm(
      billingdocument = lv_bill
      creationdate    = ls_bill1-creationdate
      caddress1       = ls_bill1-caddress1
      caddress2       = ls_bill1-caddress2
      name            = ls_bill1-name
      carsealno       = ls_bill1-carsealno
      findes          = ls_bill1-findes
      purchaseorderbycustomer = ls_bill1-purchaseorderbycustomer
      cinno           = ls_bill1-cinno
      cod             = ls_bill1-cod
      contno          = ls_bill1-contno
      coo             = ls_bill1-coo
      gstin           = ls_bill1-gstin
      iec             = ls_bill1-iec
      pol              = ls_bill1-pol
      pod              = ls_bill1-pod
      cusmar           = ls_bill1-cusmar
      descgoods        = ls_bill1-descgoods
      precarby         = ls_bill1-precarby
      por              = ls_bill1-por
      vesselno         = ls_bill1-vesselcode
      sumgrosswt       = ls_bill1-sumgrosswt
      sumnetwt         = ls_bill1-sumnetwt
      shippingbill     = ls_bill1-shippingbill
      descgoods1       = ls_bill1-descgoods1
      descgoods2       = ls_bill1-descgoods2
      var3             = ls_bill1-var3
      remarks1         = ls_bill1-remarks1
      remarks2         = ls_bill1-remarks2
      amtintext        = amtintext
      discval          = ls_amt1-discsum
      freightval       = freightval                         "ls_amt1-freightsum
      packingval       = ls_amt1-packingsum
      totalamt         =  grand_total                                     "ls_amt-totalamt
      bankname         = ls_bill1-bankname
      streetname       = ls_bill1-streetname
      cityname         = ls_bill1-cityname
      counconsignee    = ls_bill1-counconsignee
      counbuyer        = ls_bill1-counbuyer
      custbuyer        = ls_bill1-custbuyer
      custconsignee    = ls_bill1-custconsignee
      amtsum           =  line_amount                                          " ls_amt1-sumamount

      netduedate       = ls_bill1-netduedate
      transactioncurrency = ls_bill1-transactioncurrency
      customerpaymenttermsname = ls_bill1-customerpaymenttermsname
      incotermsclassificationname = ls_bill1-incotermsclassificationname
      ladingno          = ls_bill1-ladingno
      proinv            = lv_custinv "ls_bill1-proinv "ls_billingDoc-DocumentReferenceID
      ladingdt          = ls_bill1-ladingdt
      salesnoteref      = ls_bill1-salesnoteref
      ) INTO TABLE lt_return.

 endif.
    ENDLOOP.
    io_response->set_data( lt_return ).
    io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
