CLASS lhc_zi_bnkcharge_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bnkcharge_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_bnkcharge_hdr RESULT result.

    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION zi_bnkcharge_hdr~cancel RESULT result.

    METHODS checkcharges FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_bnkcharge_hdr~checkcharges.

ENDCLASS.

CLASS lhc_zi_bnkcharge_hdr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD cancel.
  ENDMETHOD.

  METHOD checkcharges.
  READ ENTITIES OF zi_bnkcharge_hdr IN LOCAL MODE
         ENTITY zi_bnkcharge_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header).

  DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

  SELECT SINGLE bnkchargename FROM zdt_bnkch_hdr
  WHERE bnkchargename = @gfs_header-Bnkchargename INTO @DATA(ls_del).
  if ls_del IS NOT INITIAL.

  DATA(lv_msg1) = |Bank Charges already created|.
  APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkcharge_hdr.

  APPEND VALUE #( %tky        = gfs_header-%tky
                  %state_area = 'Validate_Head'
                  %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = lv_msg1 ) )
  TO reported-zi_bnkcharge_hdr.
  ENDIF.

  ENDMETHOD.

ENDCLASS.
