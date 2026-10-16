CLASS zcl_gate_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GATE_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'ID' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.
    DATA rt_table TYPE TABLE OF zzvvgatehead.
    DATA: lv_gate TYPE zzvvgatehead-gatepass.


    LOOP AT lt_range[ name = 'ID' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_id) = <ls_range>-low.
      SELECT SINGLE * FROM zdt_ghead
        WHERE id = @lv_id
         INTO @DATA(ls_gatehead).

      SELECT SINGLE meins , SUM( totalqty ) AS totalqty FROM zdt_gitem
       WHERE id = @lv_id
       GROUP BY meins
       INTO @DATA(ls_qty).

      SELECT SINGLE * FROM zr_supplier_f4
      WHERE supplier = @ls_gatehead-vendorcode
      INTO @DATA(ls_supplier).
      IF ls_supplier-phonenumber1 IS NOT INITIAL.
        DATA(phone) = ls_supplier-phonenumber1.
      ELSE.
        phone = ls_supplier-phonenumber2.
      ENDIF.
*      if ls_gatehead-m = 'OUTWARD'.
*       data : lv_inv TYPE I_BillingDocument-BillingDocument.
*       data : lv_billdate type   I_BillingDocument-BillingDocumentDate.
*
*       lv_inv =   ls_gatehead-taxinvoice.
*       lv_inv = |{ lv_inv ALPHA = IN }|.
*       select SINGLE BillingDocumentDate from
*       WHERE BillingDocument = @lv_inv
*       into @lv_billdate.
*       ls_gatehead-invoicedate = lv_billdate.
*       ls_gatehead-invoice = lv_inv.
*    endif.
      lv_gate = ls_gatehead-gatepass.
      lv_gate = |{ lv_gate ALPHA = OUT }|.

      INSERT VALUE zzvvgatehead(
       id   =   ls_gatehead-id
        gatepass  =   lv_gate
        billofentrydate    =   ls_gatehead-billofentrydate
        billofentryno     =   ls_gatehead-billofentryno
        bukrs   =   ls_gatehead-bukrs
        cancel   =   ls_gatehead-cancel
        challandate   =   ls_gatehead-challandate
        challannumber    =   ls_gatehead-challannumber
        containernumber  =   ls_gatehead-containernumber
        criticality    =   ls_gatehead-criticality
        currentnumber  =   ls_gatehead-currentnumber
        currentyear    =   ls_gatehead-currentyear
        customercode   =   ls_gatehead-customercode
        customername    =   ls_gatehead-customername
        deleted     =   ls_gatehead-deleted
        deletedate  =   ls_gatehead-deletedate
        deleteuser    =   ls_gatehead-deleteuser
        deliverynumber     =   ls_gatehead-deliverynumber
        dlno   =   ls_gatehead-dlno
        drivercellno   =   ls_gatehead-drivercellno
        drivername     =   ls_gatehead-drivername
        erdat  =   ls_gatehead-erdat
        fromplace   =   ls_gatehead-fromplace
        ernam  =   ls_gatehead-ernam
        erzet   =   ls_gatehead-erzet
        gateentrydate   =   ls_gatehead-gateentrydate
        gateentrytime     =   ls_gatehead-gateentrytime
        gateout  =   ls_gatehead-gateout
        gatepassdate  =   ls_gatehead-gatepassdate
        grswt   =   ls_gatehead-grswt
        invoice = ls_gatehead-invoice
        invoicedate = ls_gatehead-invoicedate
        item = ls_gatehead-item
        lbbldate = ls_gatehead-lbbldate
        lrblno = ls_gatehead-lrblno
        meins = ls_gatehead-meins
        miningchallantpno    =   ls_gatehead-miningchallantpno
        miningpermissionno  =   ls_gatehead-miningpermissionno
        miscdate    =   ls_gatehead-miscdate
        miscnumber   =   ls_gatehead-miscnumber
        mpno    =   ls_gatehead-mpno
        multiweight     =   ls_gatehead-multiweight
        netwt  =   ls_gatehead-netwt
        noofweight    =   ls_gatehead-noofweight
        plant     =   ls_gatehead-plant
        plantgateno  =   ls_gatehead-plantgateno
        plantweighbridgeno   =   ls_gatehead-plantweighbridgeno
        printr    =   ls_gatehead-printr
        purchasingdocumentnumber  =   ls_gatehead-purchasingdocumentnumber
        rakeno   =   ls_gatehead-rakeno
        raketripno =   ls_gatehead-raketripno
        remarks   =   ls_gatehead-remarks
        rgpdate   =   ls_gatehead-rgpdate
        rgpgatepass     =   ls_gatehead-rgpgatepass
        rrdate =   ls_gatehead-rrdate
        rrno  =   ls_gatehead-rrno
        sendername   =   ls_gatehead-sendername
        shipmenttype = ls_gatehead-shipmenttype
        status = ls_gatehead-status
        tarwt = ls_gatehead-tarwt
        taxinvoice    =   ls_gatehead-taxinvoice
        testcertificate  =   ls_gatehead-testcertificate
        toplace    =   ls_gatehead-toplace
        tpno   =   ls_gatehead-tpno
        tprint   =   ls_gatehead-tprint
        transportercode     =   ls_gatehead-transportercode
        transportername  =   ls_gatehead-transportername
        type    =   ls_gatehead-type
        unloaddate     =   ls_gatehead-unloaddate
        unloadtime   =   ls_gatehead-unloadtime
        vehiclecheck   =   ls_gatehead-vehiclecheck
        vehicleoutdate     =   ls_gatehead-vehicleoutdate
        vehicleouttime  =   ls_gatehead-vehicleouttime
        vehno  =   ls_gatehead-vehno
        vendor_grswt  =   ls_gatehead-vendor_grswt
        vendor_netwt   =   ls_gatehead-vendor_netwt
        vendor_tarwt   =   ls_gatehead-vendor_tarwt
        vendorcode     =   ls_gatehead-vendorcode
        vendorname  =   ls_gatehead-vendorname
        vesselname  =   ls_gatehead-vesselname
        waybillno   =   ls_gatehead-waybillno
        wlfpl = ls_gatehead-wlfpl
        phonenumber = phone

      ) INTO TABLE rt_table.

    ENDLOOP.

    io_response->set_data( rt_table ).
    io_response->set_total_number_of_records( lines( rt_table ) ).
  ENDMETHOD.
ENDCLASS.
