CLASS lhc_zi_pterm_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_pterm_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_pterm_hdr RESULT result.

    METHODS upddet FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_pterm_hdr~upddet.

    METHODS upddate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_pterm_hdr~upddate.

    METHODS savedata FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_pterm_hdr~savedata.

    METHODS checkval FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_pterm_hdr~checkval.

ENDCLASS.

CLASS lhc_zi_pterm_hdr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD upddet.

  DATA lv_date TYPE datn.
  DATA lv_time TYPE timn.

  READ ENTITIES OF ZI_PTERM_HDR IN LOCAL MODE
         ENTITY ZI_PTERM_HDR
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         FAILED FINAL(head_failed).

  DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

  SELECT SINGLE PaymentTermsName FROM I_PaymentTermsText
  WHERE PaymentTerms = @gfs_header-zterm and language = 'E'
  Into @gfs_header-Pdesc.

  TRY.
    CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
            INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
    CATCH cx_abap_context_info_error.
  ENDTRY.

  CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

  gfs_header-Lastchngdt = lv_date.
  gfs_header-Credt      = lv_date.

  MODIFY ENTITIES OF ZI_PTERM_HDR IN LOCAL MODE
             ENTITY ZI_PTERM_HDR
             UPDATE FIELDS ( Pdesc Credt Lastchngdt )
             WITH VALUE #( ( %tky          = gfs_header-%tky
                             Pdesc         = gfs_header-Pdesc
                             Credt         = gfs_header-Credt
                             Lastchngdt    = gfs_header-Lastchngdt
                         ) ).

  ENDMETHOD.

  METHOD checkval.
  READ ENTITIES OF ZI_PTERM_HDR IN LOCAL MODE
         ENTITY ZI_PTERM_HDR
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         FAILED FINAL(head_failed).

  DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

  SELECT SINGLE * FROM Zdt_Pterm WHERE Zterm = @gfs_header-Zterm
  INTO @DATA(lt_pterm).
  if lt_pterm is not initial.
  DATA(lv_msg1) = |Payment Terms already maintained|.
  APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-ZI_PTERM_HDR.

  APPEND VALUE #( %tky        = gfs_header-%tky
                  %state_area = 'Validate_Head'
                  %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = lv_msg1 ) )
  TO reported-ZI_PTERM_HDR.
  endif.
  ENDMETHOD.

  METHOD upddate.

  DATA lv_date TYPE datn.
  DATA lv_time TYPE timn.

  READ ENTITIES OF ZI_PTERM_HDR IN LOCAL MODE
         ENTITY ZI_PTERM_HDR
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         FAILED FINAL(head_failed).

  DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

  TRY.
    CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
            INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
    CATCH cx_abap_context_info_error.
  ENDTRY.

  CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

  gfs_header-Lastchngdt = lv_date.

  MODIFY ENTITIES OF ZI_PTERM_HDR IN LOCAL MODE
             ENTITY ZI_PTERM_HDR
             UPDATE FIELDS ( Lastchngdt )
             WITH VALUE #( ( %tky          = gfs_header-%tky
                             Lastchngdt    = gfs_header-Lastchngdt
                         ) ).

  ENDMETHOD..

  METHOD savedata.
  ENDMETHOD.


ENDCLASS.
