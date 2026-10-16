CLASS lhc_zi_vend_mail DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_vend_mail RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_vend_mail RESULT result.

    METHODS copy FOR MODIFY
      IMPORTING keys FOR ACTION zi_vend_mail~copy.
    METHODS checkdata FOR VALIDATE ON SAVE
      IMPORTING keys FOR head~checkdata.

ENDCLASS.

CLASS lhc_zi_vend_mail IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_vend_mail IN LOCAL MODE
              ENTITY zi_vend_mail
              ALL FIELDS
              WITH CORRESPONDING #( keys )
              RESULT FINAL(header)
              " TODO: variable is assigned but never used (ABAP cleaner)
              FAILED FINAL(header_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).

    SELECT SINGLE * FROM zdt_vend_mail where id = @<head>-Id into @data(ls_mail).


    result = VALUE #(
        FOR gs_header IN header
        ( %tky                            = gs_header-%tky
          %field-lifnr                    = COND #( WHEN ls_mail-lifnr IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled  )
          %action-copy                    = COND #( WHEN <head>-id IS INITIAL
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled  )
        ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD copy.
    DATA : lt_head TYPE TABLE FOR CREATE zi_vend_mail.
    DATA: lv_id    TYPE zi_vend_mail-id.

    READ ENTITIES OF zi_vend_mail IN LOCAL MODE
                 ENTITY zi_vend_mail
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    SELECT SINGLE * FROM zdr_vend_mail WHERE id = @gfs_header-id INTO @DATA(ls_det).
    IF ls_det IS NOT INITIAL.

      DATA(lv_msg) = |Please save or discard then click on Simulate Button|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-head.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-head.
    ELSE.
      TRY.
          lv_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
          " handle exception
      ENDTRY.

      APPEND VALUE #( %cid      = keys[ KEY entity %key = gfs_header-%key ]-%cid
                      id        = lv_id
                      %is_draft = '00'
                      %data     = CORRESPONDING #( gfs_header ) ) TO lt_head ASSIGNING FIELD-SYMBOL(<lfs_head>).

      CLEAR <lfs_head>-lifnr.
      <lfs_head>-reflifnr = gfs_header-lifnr.
      <lfs_head>-mail1 = gfs_header-mail1.
      <lfs_head>-mail2 = gfs_header-mail2.
      <lfs_head>-mail3 = gfs_header-mail3.
      <lfs_head>-mail4 = gfs_header-mail4.
      <lfs_head>-mail5 = gfs_header-mail5.

      MODIFY ENTITIES OF zi_vend_mail IN LOCAL MODE
      ENTITY head
      CREATE FIELDS ( lifnr mail1 mail2 mail3 mail4 mail5 )
             WITH lt_head
       MAPPED DATA(mapped_create)
                 " TODO: variable is assigned but never used (ABAP cleaner)
       FAILED DATA(failed_create)
                 " TODO: variable is assigned but never used (ABAP cleaner)
       REPORTED DATA(reported_create).

      mapped-head = mapped_create-head.
    ENDIF.
  ENDMETHOD.

  METHOD checkdata.
    READ ENTITIES OF zi_vend_mail IN LOCAL MODE
                   ENTITY zi_vend_mail
                   ALL FIELDS
                   WITH CORRESPONDING #( keys )
                   RESULT FINAL(header).
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-lifnr IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_vend_mail WHERE lifnr = @gfs_header-lifnr INTO @data(ls_check).
      IF ls_check IS NOT INITIAL.
        DATA(lv_msg) = |Vendor already exist|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-head.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-head.
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
