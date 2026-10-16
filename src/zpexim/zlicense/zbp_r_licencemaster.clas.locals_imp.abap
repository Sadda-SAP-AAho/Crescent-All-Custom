CLASS lhc_licencemaster DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES     IMPORTING keys REQUEST requested_features FOR licencemaster RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION IMPORTING REQUEST requested_authorizations FOR licencemaster RESULT result.

    METHODS changedetails FOR DETERMINE ON MODIFY             IMPORTING keys FOR licencemaster~changedetails.

    METHODS update_export_inr FOR DETERMINE ON MODIFY         IMPORTING keys FOR licencemaster~update_export_inr.

    METHODS update_import_usd FOR DETERMINE ON MODIFY         IMPORTING keys FOR licencemaster~update_import_usd.

    METHODS check_export FOR VALIDATE ON SAVE              IMPORTING keys FOR licencemaster~check_export.

    METHODS check_import FOR VALIDATE ON SAVE              IMPORTING keys FOR licencemaster~check_import.

    METHODS check_mandetory FOR VALIDATE ON SAVE           IMPORTING keys FOR licencemaster~check_mandetory.

ENDCLASS.


CLASS lhc_licencemaster IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD changedetails.

    READ ENTITIES OF zr_licencemastertp IN LOCAL MODE
         ENTITY licencemaster
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    IF NOT line_exists( header[ 1 ] ).
      RETURN.
    ENDIF.

    DATA(ls_header) = header[ 1 ].
    IF ls_header-exportvalueinrc IS INITIAL.
      ls_header-exportvalueinrc = 'INR'.
    ENDIF.
    IF ls_header-exportvalueusdc IS INITIAL.
      ls_header-exportvalueusdc = 'USD'.
    ENDIF.
    IF ls_header-importvalueinrc IS INITIAL.
      ls_header-importvalueinrc = 'INR'.
    ENDIF.
    IF ls_header-importvalueusdc IS INITIAL.
      ls_header-importvalueusdc = 'USD'.
    ENDIF.

    MODIFY ENTITIES OF zr_licencemastertp IN LOCAL MODE
           ENTITY licencemaster
           UPDATE
           FIELDS ( exportvalueinrc exportvalueusdc importvalueinrc importvalueusdc )
           WITH VALUE #( ( %tky            = ls_header-%tky
                           exportvalueinrc = ls_header-exportvalueinrc
                           exportvalueusdc = ls_header-exportvalueusdc
                           importvalueinrc = ls_header-importvalueinrc
                           importvalueusdc = ls_header-importvalueusdc ) ).

  ENDMETHOD.

  METHOD update_export_inr.

    READ ENTITIES OF zr_licencemastertp IN LOCAL MODE
         ENTITY licencemaster
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    IF NOT line_exists( header[ 1 ] ).
      RETURN.
    ENDIF.

    DATA(ls_header) = header[ 1 ].
    IF ls_header-exportvalueusdv IS NOT INITIAL AND ls_header-exportexchangerate IS NOT INITIAL.
      ls_header-exportvalueinrv = ls_header-exportvalueusdv * ls_header-exportexchangerate.

      MODIFY ENTITIES OF zr_licencemastertp IN LOCAL MODE
             ENTITY licencemaster
             UPDATE
             FIELDS ( exportvalueinrv )
             WITH VALUE #( ( %tky            = ls_header-%tky
                             exportvalueinrv = ls_header-exportvalueinrv ) ).
    ENDIF.

  ENDMETHOD.

  METHOD update_import_usd.

    READ ENTITIES OF zr_licencemastertp IN LOCAL MODE
         ENTITY licencemaster
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    IF NOT line_exists( header[ 1 ] ).
      RETURN.
    ENDIF.

    DATA(ls_header) = header[ 1 ].
    IF ls_header-importvalueinrv IS NOT INITIAL AND ls_header-importexchangerate IS NOT INITIAL.
      ls_header-importvalueusdv = ls_header-importvalueinrv / ls_header-importexchangerate.

      MODIFY ENTITIES OF zr_licencemastertp IN LOCAL MODE
             ENTITY licencemaster
             UPDATE
             FIELDS ( importvalueusdv )
             WITH VALUE #( ( %tky            = ls_header-%tky
                             importvalueusdv = ls_header-importvalueusdv ) ).
    ENDIF.

  ENDMETHOD.

  METHOD check_export.

    READ ENTITIES OF zr_licencemastertp IN LOCAL MODE
         ENTITY licencemaster
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    IF NOT line_exists( header[ 1 ] ).
      RETURN.
    ENDIF.

    FINAL(ls_header) = header[ 1 ].
    IF NOT ( ls_header-exportvalidfrom IS NOT INITIAL AND ls_header-exportvalidto IS NOT INITIAL ).
      RETURN.
    ENDIF.

    IF ls_header-exportvalidfrom < ls_header-exportvalidto.
      RETURN.
    ENDIF.

    FINAL(lv_msg) = |Export Valid From Date cannot be Greater than Valid To|.

    APPEND VALUE #( %tky = ls_header-%tky ) TO failed-licencemaster.

    APPEND VALUE #( %tky                     = ls_header-%tky
                    %state_area              = 'Validate_Header'
                    %msg                     = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                      text     = lv_msg )
                    %element-exportvalidfrom = if_abap_behv=>mk-on )
           TO reported-licencemaster.

    APPEND VALUE #( %tky                   = ls_header-%tky
                    %state_area            = 'Validate_Header'
                    %msg                   = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = lv_msg )
                    %element-exportvalidto = if_abap_behv=>mk-on )
           TO reported-licencemaster.

  ENDMETHOD.

  METHOD check_import.

    READ ENTITIES OF zr_licencemastertp IN LOCAL MODE
         ENTITY licencemaster
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    IF NOT line_exists( header[ 1 ] ).
      RETURN.
    ENDIF.

    FINAL(ls_header) = header[ 1 ].
    IF NOT ( ls_header-importvalidfrom IS NOT INITIAL AND ls_header-importvalidto IS NOT INITIAL ).
      RETURN.
    ENDIF.

    IF ls_header-importvalidfrom < ls_header-importvalidto.
      RETURN.
    ENDIF.

    FINAL(lv_msg) = |Import Valid From Date cannot be Greater than Valid To|.

    APPEND VALUE #( %tky = ls_header-%tky ) TO failed-licencemaster.

    APPEND VALUE #( %tky                     = ls_header-%tky
                    %state_area              = 'Validate_Header'
                    %msg                     = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                      text     = lv_msg )
                    %element-importvalidfrom = if_abap_behv=>mk-on )
           TO reported-licencemaster.

    APPEND VALUE #( %tky                   = ls_header-%tky
                    %state_area            = 'Validate_Header'
                    %msg                   = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = lv_msg )
                    %element-importvalidto = if_abap_behv=>mk-on )
           TO reported-licencemaster.

  ENDMETHOD.

  METHOD check_mandetory.

    READ ENTITIES OF zr_licencemastertp IN LOCAL MODE
         ENTITY licencemaster
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    IF NOT line_exists( header[ 1 ] ).
      RETURN.
    ENDIF.

    FINAL(ls_header) = header[ 1 ].
    IF ls_header-licencenumber IS INITIAL.
      DATA(lv_msg) = |Licence Number Cannot be Blank|.

      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-licencemaster.

      APPEND VALUE #( %tky                   = ls_header-%tky
                      %state_area            = 'Validate_Header'
                      %msg                   = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                      text     = lv_msg )
                      %element-licencenumber = if_abap_behv=>mk-on )
             TO reported-licencemaster.
    ENDIF.

    IF ls_header-licencetype IS INITIAL.
      lv_msg = |Licence Type Cannot be Blank|.

      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-licencemaster.

      APPEND VALUE #( %tky                 = ls_header-%tky
                      %state_area          = 'Validate_Header'
                      %msg                 = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = lv_msg )
                      %element-licencetype = if_abap_behv=>mk-on )
             TO reported-licencemaster.
    ENDIF.

    IF ls_header-licencedate IS INITIAL.
      lv_msg = |Licence Date Cannot be Blank|.

      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-licencemaster.

      APPEND VALUE #( %tky                 = ls_header-%tky
                      %state_area          = 'Validate_Header'
                      %msg                 = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = lv_msg )
                      %element-licencedate = if_abap_behv=>mk-on )
             TO reported-licencemaster.
    ENDIF.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zr_licencemastertp IN LOCAL MODE
         ENTITY licencemaster
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    IF NOT line_exists( header[ 1 ] ).
      RETURN.
    ENDIF.

    FINAL(ls_header) = header[ 1 ].

    " TODO: variable is assigned but never used (ABAP cleaner)
    SELECT SINGLE * FROM zex_licence_hdr WHERE licencenumber = @ls_header-licencenumber INTO @FINAL(ls_data).
    IF sy-subrc = 0.
      APPEND VALUE #( %tky                 = ls_header-%tky
                      %field-licencenumber = if_abap_behv=>fc-f-read_only
                      %field-licencetype   = if_abap_behv=>fc-f-read_only ) TO result.
    ELSE.
      APPEND VALUE #( %tky                 = ls_header-%tky
                      %field-licencenumber = if_abap_behv=>fc-f-mandatory
                      %field-licencetype   = if_abap_behv=>fc-f-mandatory ) TO result.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
