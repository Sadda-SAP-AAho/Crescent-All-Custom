CLASS zcl_mm_po_post DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'PO'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'PO data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PO_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PO_ALOGS_01'.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_oo_adt_classrun .

    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS add_text_to_app_log_or_console
      IMPORTING i_text TYPE cl_bali_free_text_setter=>ty_text
      RAISING   cx_bali_runtime .

    DATA out             TYPE REF TO if_oo_adt_classrun_out .
    DATA application_log TYPE REF TO if_bali_log .
ENDCLASS.

CLASS ZCL_MM_PO_POST IMPLEMENTATION.


  METHOD add_text_to_app_log_or_console.
    IF sy-batch = abap_true.
      FINAL(application_log_free_text) = cl_bali_free_text_setter=>create(
        severity = if_bali_constants=>c_severity_status
        text     = i_text ).
      application_log_free_text->set_detail_level( detail_level = '1' ).
      application_log->add_item( item = application_log_free_text ).
      cl_bali_log_db=>get_instance( )->save_log( log = application_log ).
    ELSE.
      out->write( |sy-batch = abap_false | ).
      out->write( i_text ).
    ENDIF.
  ENDMETHOD.


  METHOD constructor.

    TRY.
        application_log = cl_bali_log=>create_with_header(
                               header = cl_bali_header_setter=>create( object = 'ZAPP_PO_01_LOG'
                                                                       subobject = 'ZAPP_PO_01_SUB'
                                                                       external_id = 'MATERIAL IP' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    DATA: lv_requirementtracking TYPE i_purchaseorderitemtp_2-requirementtracking,
          lv_text                TYPE char255.
    "Added by SP on 01.08.25
    DATA : lv_date_start          TYPE datum.

    lv_date_start = '20250925'.
    "End of added by SP on 01.08.25

    SELECT *
     FROM zdt_po_head
     WHERE purchaseorder IS INITIAL
       AND createdon GE @lv_date_start "Added by SP on 01.08.25
     INTO TABLE @DATA(lt_po_head).
    IF sy-subrc = 0.
      SORT lt_po_head BY errorlog ASCENDING uuid.
      SELECT *
       FROM zdt_po_item
       FOR ALL ENTRIES IN @lt_po_head
       WHERE uuid = @lt_po_head-uuid
       INTO TABLE @DATA(lt_po_item).
      IF sy-subrc = 0.
        SORT lt_po_item BY uuid itemuuid.

        SELECT *
         FROM i_purchaserequisitionitemapi01
         FOR ALL ENTRIES IN @lt_po_item
         WHERE purchaserequisition = @lt_po_item-docnum
         AND   purchaserequisitionitem = @lt_po_item-docitem
         INTO TABLE @DATA(lt_pr).
        IF sy-subrc = 0.
          SORT lt_pr BY purchaserequisition purchaserequisitionitem.
        ENDIF.

        SELECT *
         FROM i_purchasereqnacctassgmttp
         FOR ALL ENTRIES IN @lt_po_item
         WHERE purchaserequisition = @lt_po_item-docnum
         AND   purchaserequisitionitem = @lt_po_item-docitem
         INTO TABLE @DATA(lt_pr_acct).
        IF sy-subrc = 0.
          SORT lt_pr_acct BY purchaserequisition purchaserequisitionitem.
        ENDIF.

        DATA(lt_po_item_t) = lt_po_item.
        SORT lt_po_item_t BY itemcode.
        DELETE ADJACENT DUPLICATES FROM lt_po_item_t COMPARING itemcode.

        SELECT  product,
                productgroup
          FROM  i_product
          FOR ALL ENTRIES IN @lt_po_item_t
          WHERE product = @lt_po_item_t-itemcode
          INTO TABLE @DATA(lt_product).
        IF sy-subrc = 0.
          SORT lt_product BY product.
        ENDIF.
      ENDIF.
    ENDIF.

    SELECT *
    FROM zdt_ip_doc_tmg
    INTO TABLE @DATA(lt_ip_doc).

    SELECT *
    FROM zdt_ip_purgr_tmg
    INTO TABLE @DATA(lt_ip_purgr).

    TYPES: BEGIN OF ty_item,
             uuid                 TYPE char16,
             itemuuid             TYPE char16,
             purchaseorderitem    TYPE ebelp,
             material             TYPE matnr,
             plant                TYPE werks_d,
             qty                  TYPE menge_d,
             pr                   TYPE banfn,
             pritem               TYPE bnfpo,
             price                TYPE dmbtr,
             itemtext             TYPE char40,
             payment_term         TYPE dzterm,
             price_term           TYPE char64,
             quotreference        TYPE char10,
             inco_location        TYPE char64,
             currency             TYPE char3,
             costcenter           TYPE kostl,
             glaccount            TYPE hkont,
             fixedasset           TYPE char10,
             wbselementexternalid TYPE char24,
             acctcat              TYPE char1,
             taxcode              TYPE char2,
             productgroup         TYPE char4,
           END OF ty_item.

    TYPES: BEGIN OF ty_price,
             uuid            TYPE char16,
             itemuuid        TYPE char16,
             conditiontype   TYPE char4,
             conditionamount TYPE dmbtr,
           END OF ty_price.

    DATA: lt_item  TYPE STANDARD TABLE OF ty_item,
          ls_item  TYPE ty_item,

          lt_price TYPE STANDARD TABLE OF ty_price,
          ls_price TYPE ty_price.

    DATA: lv_poitem TYPE ebelp.

    LOOP AT lt_po_item INTO DATA(ls_po_item).
      APPEND INITIAL LINE TO lt_item ASSIGNING FIELD-SYMBOL(<lfs_item>).
      <lfs_item>-uuid = ls_po_item-uuid.
      <lfs_item>-itemuuid = ls_po_item-itemuuid.
      <lfs_item>-purchaseorderitem = ls_po_item-itemuuid.
      <lfs_item>-purchaseorderitem = ls_po_item-itemuuid.
      CONDENSE <lfs_item>-itemuuid.
      <lfs_item>-material = ls_po_item-itemcode.
      IF ls_po_item IS NOT INITIAL.
        DATA(ls_pr) = VALUE #( lt_pr[ purchaserequisition = ls_po_item-docnum purchaserequisitionitem = ls_po_item-docitem ] OPTIONAL ).
        DATA(ls_pr_acct) = VALUE #( lt_pr_acct[ purchaserequisition = ls_po_item-docnum purchaserequisitionitem = ls_po_item-docitem ] OPTIONAL ).
        DATA(ls_product) = VALUE #( lt_product[ product = ls_po_item-itemcode ] OPTIONAL ).
      ENDIF.
      <lfs_item>-productgroup = ls_product-productgroup.
      <lfs_item>-plant = ls_pr-plant.
      <lfs_item>-acctcat = ls_pr-accountassignmentcategory.
      <lfs_item>-qty = ls_po_item-qty.
      <lfs_item>-taxcode = ls_po_item-taxcode.
      <lfs_item>-pr = ls_po_item-docnum.
      <lfs_item>-pritem = ls_po_item-docitem.
      <lfs_item>-price = ls_po_item-price.
      <lfs_item>-itemtext = ls_po_item-description.
      <lfs_item>-payment_term = ls_po_item-zterm.
      <lfs_item>-price_term = ls_po_item-inco1.
      <lfs_item>-inco_location = ls_po_item-incoloc.
      <lfs_item>-quotreference = ls_po_item-quotreference.
      <lfs_item>-currency = ls_po_item-currency.
      <lfs_item>-costcenter = ls_pr_acct-costcenter.
      <lfs_item>-glaccount = ls_pr_acct-glaccount.
      <lfs_item>-fixedasset = ls_pr_acct-fixedasset.
      <lfs_item>-wbselementexternalid = ls_pr_acct-wbselementexternalid.

      IF ls_po_item-discount IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_price ASSIGNING FIELD-SYMBOL(<lfs_price>).
        <lfs_price>-uuid = ls_po_item-uuid.
        <lfs_price>-itemuuid = ls_po_item-itemuuid.
        CONDENSE <lfs_price>-itemuuid.
        <lfs_price>-conditiontype = 'Z000'.
        <lfs_price>-conditionamount = ls_po_item-discount.
      ENDIF.

      IF ls_po_item-pnf IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_price ASSIGNING <lfs_price>.
        <lfs_price>-uuid = ls_po_item-uuid.
        <lfs_price>-itemuuid = ls_po_item-itemuuid.
        CONDENSE <lfs_price>-itemuuid.
        <lfs_price>-conditiontype = 'ZPK2'.
        <lfs_price>-conditionamount = ls_po_item-pnf.
      ENDIF.

      IF ls_po_item-transport IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_price ASSIGNING <lfs_price>.
        <lfs_price>-uuid = ls_po_item-uuid.
        <lfs_price>-itemuuid = ls_po_item-itemuuid.
        CONDENSE <lfs_price>-itemuuid.
        <lfs_price>-conditiontype = 'ZFR2'.
        <lfs_price>-conditionamount = ls_po_item-transport.
      ENDIF.

      IF ls_po_item-othersamt IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_price ASSIGNING <lfs_price>.
        <lfs_price>-uuid = ls_po_item-uuid.
        <lfs_price>-itemuuid = ls_po_item-itemuuid.
        CONDENSE <lfs_price>-itemuuid.
        <lfs_price>-conditiontype = 'ZOTH'.
        <lfs_price>-conditionamount = ls_po_item-othersamt.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_po_head ASSIGNING FIELD-SYMBOL(<lfs_po_head>).

      DATA(ls_po_item_h) = VALUE #( lt_po_item[ uuid = <lfs_po_head>-uuid ] OPTIONAL ).
      DATA(ls_item_t) = VALUE #( lt_item[ uuid = <lfs_po_head>-uuid ] OPTIONAL ).
      DATA(ls_ip_doc) = VALUE #( lt_ip_doc[ materialgroup = ls_item_t-productgroup ] OPTIONAL ).
      DATA(ls_ip_purgr) = VALUE #( lt_ip_purgr[ purchasermail = <lfs_po_head>-purchaser ] OPTIONAL ).

      MODIFY ENTITIES OF i_purchaseordertp_2 ENTITY purchaseorder
    CREATE FIELDS ( purchaseordertype
                    companycode
                    purchasingorganization
                    purchasinggroup
                    supplier
                    paymentterms
                    correspncinternalreference
                    documentcurrency                  " ✅ Added
                    purchasingcompletenessstatus      " ✅ Added
                    incotermslocation1
                    incotermsclassification )
    WITH VALUE #( ( %cid                         = <lfs_po_head>-uuid
                    purchaseordertype            = 'ZMAT'
                    companycode                  = '1000'
                    purchasingorganization       = '1000'
                    purchasinggroup              = '101'
                    supplier                     = <lfs_po_head>-vendor
                    paymentterms                 = ls_po_item_h-zterm
                    documentcurrency             = ls_po_item_h-currency
                    purchasingcompletenessstatus = 'H'
                    incotermslocation1           = ls_po_item_h-incoloc
                    incotermsclassification      = ls_po_item_h-inco1
                    %control = VALUE #(
                      purchaseordertype            = cl_abap_behv=>flag_changed
                      companycode                  = cl_abap_behv=>flag_changed
                      purchasingorganization       = cl_abap_behv=>flag_changed
                      purchasinggroup              = cl_abap_behv=>flag_changed
                      supplier                     = cl_abap_behv=>flag_changed
                      paymentterms                 = cl_abap_behv=>flag_changed
                      correspncinternalreference   = cl_abap_behv=>flag_changed
                      documentcurrency             = cl_abap_behv=>flag_changed
                      purchasingcompletenessstatus = cl_abap_behv=>flag_changed
                      incotermslocation1           = cl_abap_behv=>flag_changed
                      incotermsclassification      = cl_abap_behv=>flag_changed
                    ) ) )
                CREATE BY \_purchaseorderitem
                FIELDS ( material manufacturermaterial plant orderquantity purchaseorderitem netpriceamount taxcode requirementtracking
                         purchaserequisition purchaserequisitionitem purchaseorderitemtext incotermslocation1 incotermsclassification )
                WITH VALUE #(
                ( %cid_ref = <lfs_po_head>-uuid
                  %target = VALUE #(  FOR ls_item_1 IN lt_item  WHERE ( uuid = <lfs_po_head>-uuid )
                                    (  %cid = ls_item_1-itemuuid
                                       purchaseorderitem = ls_item_1-itemuuid
                                        material = ls_item_1-material
                                        manufacturermaterial = ls_item_1-material
                                        plant = ls_item_1-plant
                                        orderquantity = ls_item_1-qty
                                        netpriceamount = ls_item_1-price
                                        purchaserequisition = ls_item_1-pr
                                        purchaserequisitionitem = ls_item_1-pritem
                                        purchaseorderitemtext = ls_item_1-itemtext
                                        incotermslocation1 = ls_item_1-inco_location
                                        incotermsclassification = ls_item_1-price_term
                                        taxcode = ls_item_1-taxcode
                                        requirementtracking = ls_item_1-quotreference
                                        %control = VALUE #( material = cl_abap_behv=>flag_changed
                                    manufacturermaterial = cl_abap_behv=>flag_changed
                                    plant = cl_abap_behv=>flag_changed
                                    orderquantity = cl_abap_behv=>flag_changed
                                    netpriceamount = cl_abap_behv=>flag_changed
                                    purchaserequisition = cl_abap_behv=>flag_changed
                                    purchaserequisitionitem = cl_abap_behv=>flag_changed
                                    purchaseorderitemtext = cl_abap_behv=>flag_changed
                                    incotermslocation1 = cl_abap_behv=>flag_changed
                                    incotermsclassification = cl_abap_behv=>flag_changed
                                    taxcode = cl_abap_behv=>flag_changed
                                    requirementtracking = cl_abap_behv=>flag_changed
                                    )
                                    ) ) ) )

                ENTITY purchaseorderitem
                CREATE BY \_purordaccountassignment
                FIELDS ( costcenter glaccount fixedasset wbselementexternalid purchaseorderitem accountassignmentnumber )
                WITH VALUE #( FOR ls_item_2 IN lt_item WHERE ( uuid = <lfs_po_head>-uuid AND acctcat IS NOT INITIAL )
                                ( %cid_ref = ls_item_2-itemuuid
                                %target = VALUE #( (
                                %cid = ls_item_2-itemuuid && ls_item_2-glaccount && ls_item_2-costcenter && ls_item_2-fixedasset && ls_item_2-wbselementexternalid
                                purchaseorderitem = ls_item_2-itemuuid
                                accountassignmentnumber = ls_item_2-itemuuid
                                costcenter = ls_item_2-costcenter
                                glaccount = ls_item_2-glaccount
                                fixedasset = ls_item_2-fixedasset
                                wbselementexternalid = ls_item_2-wbselementexternalid
                                        %control = VALUE #( purchaseorderitem = cl_abap_behv=>flag_changed
                                    costcenter = cl_abap_behv=>flag_changed
                                    glaccount = cl_abap_behv=>flag_changed
                                    fixedasset = cl_abap_behv=>flag_changed
                                    wbselementexternalid = cl_abap_behv=>flag_changed
                                    accountassignmentnumber = cl_abap_behv=>flag_changed
                                    )
                                 ) ) ) )

                ENTITY purchaseorderitem
                CREATE BY \_purordpricingelement
                FIELDS ( purchaseorderitem conditiontype conditionbaseamount pricingdocument pricingdocumentitem )
                WITH VALUE #( FOR ls_price_1 IN lt_price WHERE ( uuid = <lfs_po_head>-uuid )
                                ( %cid_ref = ls_price_1-itemuuid
                                 %target = VALUE #( (
                                %cid = ls_price_1-itemuuid && ls_price_1-conditiontype
                                purchaseorderitem = ls_price_1-itemuuid
                                conditiontype = ls_price_1-conditiontype
                                conditionbaseamount = ls_price_1-conditionamount
                                        %control = VALUE #( purchaseorderitem = cl_abap_behv=>flag_changed
                                    conditiontype = cl_abap_behv=>flag_changed
                                    conditionbaseamount = cl_abap_behv=>flag_changed
                                    )
                                 ) ) ) )

*         REPORTED DATA(ls_reported)
*         MAPPED DATA(ls_mapped)
*         FAILED DATA(ls_failed).
            REPORTED DATA(it_reported)
                 MAPPED DATA(lt_mapped)
                 FAILED DATA(it_failed).


      COMMIT ENTITIES BEGIN
       RESPONSE OF i_purchaseordertp_2
       FAILED DATA(lt_failed)
       REPORTED DATA(lt_reported).
      COMMIT ENTITIES END.

      IF lt_failed IS NOT INITIAL.
        LOOP AT lt_reported-purchaseorder ASSIGNING FIELD-SYMBOL(<ls_reported>).
          FINAL(lv_result01) = <ls_reported>-%msg->if_message~get_text( ).
          IF sy-tabix = 1.
            lv_text = lv_result01.
          ELSE.
            lv_text = |{ lv_text } / { lv_result01 }|.
          ENDIF.
        ENDLOOP.
        <lfs_po_head>-errorlog = lv_text.
      ELSE.
        lv_requirementtracking = ls_po_item_h-quotreference.
        SELECT SINGLE *
          FROM i_purchaseorderitemapi01
          WHERE requirementtracking = @lv_requirementtracking
          INTO @DATA(ls_purchaseorderapi01).
        IF ls_purchaseorderapi01 IS NOT INITIAL.
          <lfs_po_head>-purchaseorder = ls_purchaseorderapi01-purchaseorder.
          CLEAR : <lfs_po_head>-errorlog.
        ENDIF.
        CLEAR: ls_purchaseorderapi01.
      ENDIF.

      MODIFY zdt_po_head FROM @<lfs_po_head>. "Added by SP on 05.08.25
      CLEAR : lt_failed, lt_reported,it_reported,lt_mapped,
              ls_po_item_h, ls_item_t, ls_ip_doc, ls_ip_purgr , lv_text. "Added by SP on 06.08.25 "ls_reported, ls_mapped, ls_failed, "Added by SP on 06.08.25

*      EXIT.
    ENDLOOP.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA: lv_requirementtracking TYPE i_purchaseorderitemtp_2-requirementtracking,
          lv_text                TYPE char255.

    "Added by SP on 05.08.25
    DATA : lv_date_start          TYPE datum.

    lv_date_start = '20250925'.
    "End of added by SP on 05.08.25

    SELECT *
     FROM zdt_po_head
     WHERE purchaseorder IS INITIAL
     AND createdon GE @lv_date_start "Added by SP on 05.08.25
     INTO TABLE @DATA(lt_po_head).
    IF sy-subrc = 0.
      SORT lt_po_head BY errorlog ASCENDING uuid.
      SELECT *
       FROM zdt_po_item
       FOR ALL ENTRIES IN @lt_po_head
       WHERE uuid = @lt_po_head-uuid
       INTO TABLE @DATA(lt_po_item).
      IF sy-subrc = 0.
        SORT lt_po_item BY uuid itemuuid.

        SELECT *
         FROM i_purchaserequisitionitemapi01
         FOR ALL ENTRIES IN @lt_po_item
         WHERE purchaserequisition = @lt_po_item-docnum
         AND   purchaserequisitionitem = @lt_po_item-docitem
         INTO TABLE @DATA(lt_pr).
        IF sy-subrc = 0.
          SORT lt_pr BY purchaserequisition purchaserequisitionitem.
        ENDIF.

        SELECT *
         FROM i_purchasereqnacctassgmttp
         FOR ALL ENTRIES IN @lt_po_item
         WHERE purchaserequisition = @lt_po_item-docnum
         AND   purchaserequisitionitem = @lt_po_item-docitem
         INTO TABLE @DATA(lt_pr_acct).
        IF sy-subrc = 0.
          SORT lt_pr_acct BY purchaserequisition purchaserequisitionitem.
        ENDIF.

        DATA(lt_po_item_t) = lt_po_item.
        SORT lt_po_item_t BY itemcode.
        DELETE ADJACENT DUPLICATES FROM lt_po_item_t COMPARING itemcode.

        SELECT  product,
                productgroup
          FROM  i_product
          FOR ALL ENTRIES IN @lt_po_item_t
          WHERE product = @lt_po_item_t-itemcode
          INTO TABLE @DATA(lt_product).
        IF sy-subrc = 0.
          SORT lt_product BY product.
        ENDIF.
      ENDIF.
    ENDIF.

    SELECT *
    FROM zdt_ip_doc_tmg
    INTO TABLE @DATA(lt_ip_doc).

    SELECT *
    FROM zdt_ip_purgr_tmg
    INTO TABLE @DATA(lt_ip_purgr).

    TYPES: BEGIN OF ty_item,
             uuid                 TYPE char16,
             itemuuid             TYPE char16,
             purchaseorderitem    TYPE ebelp,
             material             TYPE matnr,
             plant                TYPE werks_d,
             qty                  TYPE menge_d,
             pr                   TYPE banfn,
             pritem               TYPE bnfpo,
             price                TYPE dmbtr,
             itemtext             TYPE char40,
             payment_term         TYPE dzterm,
             price_term           TYPE char64,
             quotreference        TYPE char10,
             inco_location        TYPE char64,
             currency             TYPE char3,
             costcenter           TYPE kostl,
             glaccount            TYPE hkont,
             fixedasset           TYPE char10,
             wbselementexternalid TYPE char24,
             acctcat              TYPE char1,
             taxcode              TYPE char2,
             productgroup         TYPE char4,
           END OF ty_item.

    TYPES: BEGIN OF ty_price,
             uuid            TYPE char16,
             itemuuid        TYPE char16,
             conditiontype   TYPE char4,
             conditionamount TYPE dmbtr,
           END OF ty_price.

    DATA: lt_item  TYPE STANDARD TABLE OF ty_item,
          ls_item  TYPE ty_item,

          lt_price TYPE STANDARD TABLE OF ty_price,
          ls_price TYPE ty_price.

    DATA: lv_poitem TYPE ebelp.

    LOOP AT lt_po_item INTO DATA(ls_po_item).
      APPEND INITIAL LINE TO lt_item ASSIGNING FIELD-SYMBOL(<lfs_item>).
      <lfs_item>-uuid             = ls_po_item-uuid.
      <lfs_item>-itemuuid         = ls_po_item-itemuuid.
      <lfs_item>-purchaseorderitem = ls_po_item-itemuuid.
      CONDENSE <lfs_item>-itemuuid.
      <lfs_item>-material         = ls_po_item-itemcode.

      DATA(ls_pr)      = VALUE #( lt_pr[ purchaserequisition     = ls_po_item-docnum
                                         purchaserequisitionitem = ls_po_item-docitem ] OPTIONAL ).
      DATA(ls_pr_acct) = VALUE #( lt_pr_acct[ purchaserequisition     = ls_po_item-docnum
                                              purchaserequisitionitem = ls_po_item-docitem ] OPTIONAL ).
      DATA(ls_product) = VALUE #( lt_product[ product = ls_po_item-itemcode ] OPTIONAL ).

      <lfs_item>-productgroup        = ls_product-productgroup.
      <lfs_item>-plant               = ls_pr-plant.
      <lfs_item>-acctcat             = ls_pr-accountassignmentcategory.
      <lfs_item>-qty                 = ls_po_item-qty.
      <lfs_item>-taxcode             = ls_po_item-taxcode.
      <lfs_item>-pr                  = ls_po_item-docnum.
      <lfs_item>-pritem              = ls_po_item-docitem.
      <lfs_item>-price               = ls_po_item-price.
      <lfs_item>-itemtext            = ls_po_item-description.
      <lfs_item>-payment_term        = ls_po_item-zterm.
      <lfs_item>-price_term          = ls_po_item-inco1.
      <lfs_item>-inco_location       = ls_po_item-incoloc.
      <lfs_item>-quotreference       = ls_po_item-quotreference.
      <lfs_item>-currency            = ls_po_item-currency.
      <lfs_item>-costcenter          = ls_pr_acct-costcenter.
      <lfs_item>-glaccount           = ls_pr_acct-glaccount.
      <lfs_item>-fixedasset          = ls_pr_acct-fixedasset.
      <lfs_item>-wbselementexternalid = ls_pr_acct-wbselementexternalid.

      IF ls_po_item-discount IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_price ASSIGNING FIELD-SYMBOL(<lfs_price>).
        <lfs_price>-uuid            = ls_po_item-uuid.
        <lfs_price>-itemuuid        = ls_po_item-itemuuid.
        CONDENSE <lfs_price>-itemuuid.
        <lfs_price>-conditiontype   = 'Z000'.
        <lfs_price>-conditionamount = ls_po_item-discount.
      ENDIF.

      IF ls_po_item-pnf IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_price ASSIGNING <lfs_price>.
        <lfs_price>-uuid            = ls_po_item-uuid.
        <lfs_price>-itemuuid        = ls_po_item-itemuuid.
        CONDENSE <lfs_price>-itemuuid.
        <lfs_price>-conditiontype   = 'ZPK2'.
        <lfs_price>-conditionamount = ls_po_item-pnf.
      ENDIF.

      IF ls_po_item-transport IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_price ASSIGNING <lfs_price>.
        <lfs_price>-uuid            = ls_po_item-uuid.
        <lfs_price>-itemuuid        = ls_po_item-itemuuid.
        CONDENSE <lfs_price>-itemuuid.
        <lfs_price>-conditiontype   = 'ZFR2'.
        <lfs_price>-conditionamount = ls_po_item-transport.
      ENDIF.

      IF ls_po_item-othersamt IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_price ASSIGNING <lfs_price>.
        <lfs_price>-uuid            = ls_po_item-uuid.
        <lfs_price>-itemuuid        = ls_po_item-itemuuid.
        CONDENSE <lfs_price>-itemuuid.
        <lfs_price>-conditiontype   = 'ZOTH'.
        <lfs_price>-conditionamount = ls_po_item-othersamt.
      ENDIF.

    ENDLOOP.

    LOOP AT lt_po_head ASSIGNING FIELD-SYMBOL(<lfs_po_head>).

      CLEAR: lv_text.
      CHECK <lfs_po_head>-uuid IS NOT INITIAL.

      DATA(ls_po_item_h) = VALUE #( lt_po_item[ uuid = <lfs_po_head>-uuid ] OPTIONAL ).
      DATA(ls_item_t)    = VALUE #( lt_item[ uuid = <lfs_po_head>-uuid ] OPTIONAL ).
      DATA(ls_ip_doc)    = VALUE #( lt_ip_doc[ materialgroup = ls_item_t-productgroup ] OPTIONAL ).
      DATA(ls_ip_purgr)  = VALUE #( lt_ip_purgr[ purchasermail = <lfs_po_head>-purchaser ] OPTIONAL ).

      MODIFY ENTITIES OF i_purchaseordertp_2 ENTITY purchaseorder
        CREATE FIELDS ( purchaseordertype companycode purchasingorganization purchasinggroup supplier paymentterms
                        correspncinternalreference incotermslocation1 incotermsclassification )
        WITH VALUE #( (
          %cid                         = 'HDR-' && <lfs_po_head>-uuid  "★ Prefixed to avoid clash with item %cid
          purchaseordertype            = 'ZMAT'
          companycode                  = '1000'
          purchasingorganization       = '1000'
          purchasinggroup              = '101'
          supplier                     = <lfs_po_head>-vendor
          paymentterms                 = ls_po_item_h-zterm
          documentcurrency             = ls_po_item_h-currency
          correspncinternalreference   = ls_po_item_h-uuid
          purchasingcompletenessstatus = 'H'
          incotermslocation1           = ls_po_item_h-incoloc
          incotermsclassification      = ls_po_item_h-inco1
          %control = VALUE #(
            purchaseordertype            = cl_abap_behv=>flag_changed
            companycode                  = cl_abap_behv=>flag_changed
            purchasingorganization       = cl_abap_behv=>flag_changed
            purchasinggroup              = cl_abap_behv=>flag_changed
            supplier                     = cl_abap_behv=>flag_changed
            paymentterms                 = cl_abap_behv=>flag_changed
            documentcurrency             = cl_abap_behv=>flag_changed
            correspncinternalreference   = cl_abap_behv=>flag_changed
            purchasingcompletenessstatus = cl_abap_behv=>flag_changed
            incotermslocation1           = cl_abap_behv=>flag_changed
            incotermsclassification      = cl_abap_behv=>flag_changed ) ) )

        CREATE BY \_purchaseorderitem
        FIELDS ( material manufacturermaterial plant orderquantity purchaseorderitem netpriceamount taxcode
                 requirementtracking purchaserequisition purchaserequisitionitem purchaseorderitemtext
                 incotermslocation1 incotermsclassification )
        WITH VALUE #( (
          %cid_ref = 'HDR-' && <lfs_po_head>-uuid  "★ Must match header %cid above
          %target  = VALUE #( FOR ls_item_1 IN lt_item WHERE ( uuid = <lfs_po_head>-uuid )
                              ( %cid                    = 'ITM-' && ls_item_1-itemuuid  "★ Prefixed
                                purchaseorderitem       = ls_item_1-itemuuid
                                material                = ls_item_1-material
                                manufacturermaterial    = ls_item_1-material
                                plant                   = ls_item_1-plant
                                orderquantity           = ls_item_1-qty
                                netpriceamount          = ls_item_1-price
                                purchaserequisition     = ls_item_1-pr
                                purchaserequisitionitem = ls_item_1-pritem
                                purchaseorderitemtext   = ls_item_1-itemtext
                                incotermslocation1      = ls_item_1-inco_location
                                incotermsclassification = ls_item_1-price_term
                                taxcode                 = ls_item_1-taxcode
                                requirementtracking     = ls_item_1-quotreference
                                %control = VALUE #(
                                  material                = cl_abap_behv=>flag_changed
                                  manufacturermaterial    = cl_abap_behv=>flag_changed
                                  plant                   = cl_abap_behv=>flag_changed
                                  orderquantity           = cl_abap_behv=>flag_changed
                                  netpriceamount          = cl_abap_behv=>flag_changed
                                  purchaserequisition     = cl_abap_behv=>flag_changed
                                  purchaserequisitionitem = cl_abap_behv=>flag_changed
                                  purchaseorderitemtext   = cl_abap_behv=>flag_changed
                                  incotermslocation1      = cl_abap_behv=>flag_changed
                                  incotermsclassification = cl_abap_behv=>flag_changed
                                  taxcode                 = cl_abap_behv=>flag_changed
                                  requirementtracking     = cl_abap_behv=>flag_changed ) ) ) ) )

        ENTITY purchaseorderitem
        CREATE BY \_purordaccountassignment
        FIELDS ( costcenter glaccount fixedasset wbselementexternalid purchaseorderitem accountassignmentnumber )
        WITH VALUE #( FOR ls_item_2 IN lt_item WHERE ( uuid = <lfs_po_head>-uuid AND acctcat IS NOT INITIAL )
                      ( %cid_ref = 'ITM-' && ls_item_2-itemuuid  "★ Must match item %cid above
                        %target  = VALUE #( (
                          %cid                    = 'ACC-' && ls_item_2-itemuuid  "★ Prefixed — fixes the dump!
                          "  ^^^ THIS was the root cause: when GL/CC fields were initial,
                          "  old code produced %cid = '10' same as item %cid = '10'
                          purchaseorderitem       = ls_item_2-itemuuid
                          accountassignmentnumber = ls_item_2-itemuuid
                          costcenter              = ls_item_2-costcenter
                          glaccount               = ls_item_2-glaccount
                          fixedasset              = ls_item_2-fixedasset
                          wbselementexternalid    = ls_item_2-wbselementexternalid
                          %control = VALUE #(
                            purchaseorderitem       = cl_abap_behv=>flag_changed
                            costcenter              = cl_abap_behv=>flag_changed
                            glaccount               = cl_abap_behv=>flag_changed
                            fixedasset              = cl_abap_behv=>flag_changed
                            wbselementexternalid    = cl_abap_behv=>flag_changed
                            accountassignmentnumber = cl_abap_behv=>flag_changed ) ) ) ) )

        ENTITY purchaseorderitem
        CREATE BY \_purordpricingelement
        FIELDS ( purchaseorderitem conditiontype conditionbaseamount pricingdocument pricingdocumentitem )
        WITH VALUE #( FOR ls_price_1 IN lt_price WHERE ( uuid = <lfs_po_head>-uuid )
                      ( %cid_ref = 'ITM-' && ls_price_1-itemuuid  "★ Must match item %cid above
                        %target  = VALUE #( (
                          %cid                = 'PRC-' && ls_price_1-itemuuid && ls_price_1-conditiontype  "★ Prefixed
                          purchaseorderitem   = ls_price_1-itemuuid
                          conditiontype       = ls_price_1-conditiontype
                          conditionbaseamount = ls_price_1-conditionamount
                          %control = VALUE #(
                            purchaseorderitem   = cl_abap_behv=>flag_changed
                            conditiontype       = cl_abap_behv=>flag_changed
                            conditionbaseamount = cl_abap_behv=>flag_changed ) ) ) ) )

        REPORTED DATA(ls_reported)
        MAPPED   DATA(ls_mapped)
        FAILED   DATA(ls_failed).

      IF ls_failed IS INITIAL.

        COMMIT ENTITIES BEGIN
          RESPONSE OF i_purchaseordertp_2
          FAILED   DATA(lt_failed)
          REPORTED DATA(lt_reported).
        COMMIT ENTITIES END.

        IF lt_failed IS NOT INITIAL.
          LOOP AT lt_reported-purchaseorder ASSIGNING FIELD-SYMBOL(<ls_reported>).
            DATA(lv_result01) = <ls_reported>-%msg->if_message~get_text( ).
            IF sy-tabix = 1.
              lv_text = lv_result01.
            ELSE.
              lv_text = |{ lv_text } / { lv_result01 }|.
            ENDIF.
            CLEAR: lv_result01.
          ENDLOOP.
          <lfs_po_head>-errorlog = lv_text.
        ELSE.
          lv_requirementtracking = ls_po_item_h-quotreference.
          SELECT SINGLE *
            FROM i_purchaseorderitemapi01
            WHERE requirementtracking = @lv_requirementtracking
            INTO @DATA(ls_purchaseorderapi01).
          IF ls_purchaseorderapi01 IS NOT INITIAL.
            <lfs_po_head>-purchaseorder = ls_purchaseorderapi01-purchaseorder.
            CLEAR: <lfs_po_head>-errorlog.
          ENDIF.

          CLEAR: ls_purchaseorderapi01.
        ENDIF.

      ELSEIF ls_failed IS NOT INITIAL.

        COMMIT ENTITIES BEGIN
          RESPONSE OF i_purchaseordertp_2
          FAILED   DATA(lt_failed1)
          REPORTED DATA(lt_reported1).
        COMMIT ENTITIES END.

        LOOP AT lt_reported1-purchaseorder ASSIGNING FIELD-SYMBOL(<ls_reported1>).
          DATA(lv_result02) = <ls_reported1>-%msg->if_message~get_text( ).
          IF sy-tabix = 1.
            lv_text = lv_result02.
          ELSE.
            lv_text = |{ lv_text } / { lv_result02 }|.
          ENDIF.
          CLEAR: lv_result02.
        ENDLOOP.
        <lfs_po_head>-errorlog = lv_text.

      ENDIF.

      MODIFY zdt_po_head FROM @<lfs_po_head>.
      CLEAR: lt_failed, lt_reported, ls_reported, ls_mapped, ls_failed,
             ls_po_item_h, ls_item_t, ls_ip_doc, ls_ip_purgr, lv_text.
*      EXIT.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
