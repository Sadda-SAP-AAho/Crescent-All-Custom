CLASS lhc_ZI_GAP_TRACKER DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_gap_tracker RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_gap_tracker RESULT result.

    METHODS headerdetails1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gap_tracker~headerdetails1.

    METHODS headerdetails FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_gap_tracker~headerdetails.
    METHODS updatelog FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_gap_tracker~updatelog.

ENDCLASS.

CLASS lhc_ZI_GAP_TRACKER IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD headerdetails1.
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    DATA: lv_del TYPE char10.

    READ ENTITIES OF zi_gap_tracker IN LOCAL MODE
         ENTITY zi_gap_tracker
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    " ---------------------------------------------------------------------
    " ==Save Internal Parameters
    " ---------------------------------------------------------------------
    LOOP AT header ASSIGNING FIELD-SYMBOL(<gfs_header>).

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      <gfs_header>-LastChangedBy         = sy-uname.
      <gfs_header>-LastChangedOn         = lv_date.
      <gfs_header>-LastChangedAt         = lv_time.

      SELECT  SINGLE * FROM zdt_gap_tracker
      WHERE modulename = @<gfs_header>-ModuleName
      AND serialnumber = @<gfs_header>-SerialNumber
       INTO @DATA(wa_del).

      IF <gfs_header>-Description IS INITIAL.
        <gfs_header>-description = wa_del-Description.
      ENDIF.
      IF <gfs_header>-WricefCategory IS INITIAL.
        <gfs_header>-WricefCategory = wa_del-wricefcategory.
      ENDIF.
      IF <gfs_header>-Priority IS INITIAL.
        <gfs_header>-priority = wa_del-Priority.
      ENDIF.
      IF <gfs_header>-Entity IS INITIAL.
        <gfs_header>-entity = wa_del-Entity.
      ENDIF.
      IF <gfs_header>-DevelopmentStatus IS INITIAL.
        <gfs_header>-DevelopmentStatus = wa_del-developmentstatus.
      ENDIF.
      IF <gfs_header>-TestingStatus IS INITIAL.
        <gfs_header>-TestingStatus = wa_del-testingstatus.
      ENDIF.
      IF <gfs_header>-ClientTestingStatus IS INITIAL.
        <gfs_header>-ClientTestingStatus = wa_del-clienttestingstatus.
      ENDIF.
      IF <gfs_header>-Developer IS INITIAL.
        <gfs_header>-developer = wa_del-Developer.
      ENDIF.
      IF <gfs_header>-Finctional IS INITIAL.
        <gfs_header>-finctional = wa_del-Finctional.
      ENDIF.
      IF <gfs_header>-TransportNo IS INITIAL.
        <gfs_header>-TransportNo = wa_del-transportno.
      ENDIF.
      IF <gfs_header>-Deployed IS INITIAL.
        <gfs_header>-deployed = wa_del-Deployed.
      ENDIF.
      IF <gfs_header>-Remarks IS INITIAL.
        <gfs_header>-remarks = wa_del-Remarks.
      ENDIF.
      IF <gfs_header>-Stage IS INITIAL.
        <gfs_header>-stage = wa_del-Stage.
      ENDIF.
      IF <gfs_header>-FdsStatus IS INITIAL.
        <gfs_header>-FdsStatus = wa_del-fdsstatus.
      ENDIF.
      IF <gfs_header>-TsdStatus IS INITIAL.
        <gfs_header>-TsdStatus = wa_del-tsdstatus.
      ENDIF.
*     CALL FUNCTION 'DD_DOMVALUES_GET'


      MODIFY ENTITIES OF zi_gap_tracker IN LOCAL MODE
             ENTITY zi_gap_tracker
             UPDATE
             FIELDS ( Description WricefCategory Priority Entity DevelopmentStatus TestingStatus
             ClientTestingStatus Developer Finctional TransportNo Deployed Remarks Stage FdsStatus TsdStatus
             LastChangedBy LastChangedAt LastChangedOn )
             WITH VALUE #( ( %tky          = <gfs_header>-%tky
                             Description       = <gfs_header>-Description
                             WricefCategory       = <gfs_header>-WricefCategory
                             Priority         = <gfs_header>-Priority
                             Entity        = <gfs_header>-Entity
                             DevelopmentStatus        = <gfs_header>-DevelopmentStatus
                             TestingStatus = <gfs_header>-TestingStatus
                             ClientTestingStatus = <gfs_header>-ClientTestingStatus
                             Developer = <gfs_header>-Developer
                             Finctional = <gfs_header>-Finctional
                             TransportNo = <gfs_header>-TransportNo
                             Deployed = <gfs_header>-Deployed
                             Remarks = <gfs_header>-Remarks
                             Stage = <gfs_header>-Stage
                             FdsStatus = <gfs_header>-FdsStatus
                             TsdStatus = <gfs_header>-TsdStatus
                             LastChangedBy = <gfs_header>-LastChangedBy
                             LastChangedAt = <gfs_header>-LastChangedAt
                             LastChangedOn = <gfs_header>-LastChangedOn

                                %control-Description    = if_abap_behv=>mk-on
                                 %control-WricefCategory = if_abap_behv=>mk-on
                                %control-Priority   = if_abap_behv=>mk-on
                                 %control-Entity = if_abap_behv=>mk-on
                                %control-DevelopmentStatus   = if_abap_behv=>mk-on
                                 %control-TestingStatus = if_abap_behv=>mk-on
                                  %control-ClientTestingStatus = if_abap_behv=>mk-on
                                   %control-Developer = if_abap_behv=>mk-on
                                  %control-Finctional = if_abap_behv=>mk-on
                                 %control-TransportNo = if_abap_behv=>mk-on
                                 %control-Deployed = if_abap_behv=>mk-on
                                 %control-Remarks = if_abap_behv=>mk-on
                                 %control-Stage = if_abap_behv=>mk-on
                                 %control-FdsStatus = if_abap_behv=>mk-on
                                 %control-TsdStatus = if_abap_behv=>mk-on
                                 %control-LastChangedBy = if_abap_behv=>mk-on
                                 %control-LastChangedAt = if_abap_behv=>mk-on
                                 %control-LastChangedOn = if_abap_behv=>mk-on

                                  ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD headerdetails.
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    DATA: lv_del TYPE char10.

    READ ENTITIES OF zi_gap_tracker IN LOCAL MODE
         ENTITY  zi_gap_tracker
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    " ---------------------------------------------------------------------
    " ==Save Internal Parameters
    " ---------------------------------------------------------------------
    LOOP AT header ASSIGNING FIELD-SYMBOL(<gfs_header>).

      SELECT * FROM zdt_gap_tracker
       WHERE modulename = @<gfs_header>-ModuleName
       INTO TABLE @DATA(lt_gap_tracker).
      DATA(count) = lines( lt_gap_tracker ) .
      DATA(count1) = count + 1.
      <gfs_header>-SerialNumber = |{ <gfs_header>-ModuleName }{  count1 }|.
      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      <gfs_header>-LastChangedBy         = sy-uname.
      <gfs_header>-LastChangedOn         = lv_date."sy-datum.
      <gfs_header>-LastChangedAt         = lv_time."sy-uzeit.


      MODIFY ENTITIES OF zi_gap_tracker IN LOCAL MODE
              ENTITY zi_gap_tracker
              UPDATE
              FIELDS ( SerialNumber ModuleName Description WricefCategory Priority Entity DevelopmentStatus TestingStatus
              ClientTestingStatus Developer Finctional TransportNo Deployed Remarks Stage FdsStatus TsdStatus
              LastChangedBy LastChangedAt LastChangedOn )
              WITH VALUE #( ( %tky                 = <gfs_header>-%tky
                              SerialNumber         = <gfs_header>-SerialNumber
                              ModuleName           = <gfs_header>-ModuleName
                              Description          = <gfs_header>-Description
                              WricefCategory       = <gfs_header>-WricefCategory
                              Priority             = <gfs_header>-Priority
                              Entity               = <gfs_header>-Entity
                              DevelopmentStatus    = <gfs_header>-DevelopmentStatus
                              TestingStatus        = <gfs_header>-TestingStatus
                              ClientTestingStatus  = <gfs_header>-ClientTestingStatus
                              Developer            = <gfs_header>-Developer
                              Finctional           = <gfs_header>-Finctional
                              TransportNo          = <gfs_header>-TransportNo
                              Deployed             = <gfs_header>-Deployed
                              Remarks              = <gfs_header>-Remarks
                              Stage                = <gfs_header>-Stage
                              FdsStatus            = <gfs_header>-FdsStatus
                              TsdStatus            = <gfs_header>-TsdStatus
                              LastChangedBy = <gfs_header>-LastChangedBy
                             LastChangedAt = <gfs_header>-LastChangedAt
                             LastChangedOn = <gfs_header>-LastChangedOn


                                 %control-SerialNumber           = if_abap_behv=>mk-on
                                  %control-ModuleName           = if_abap_behv=>mk-on
                                 %control-Description           = if_abap_behv=>mk-on
                                  %control-WricefCategory       = if_abap_behv=>mk-on
                                 %control-Priority              = if_abap_behv=>mk-on
                                  %control-Entity               = if_abap_behv=>mk-on
                                 %control-DevelopmentStatus     = if_abap_behv=>mk-on
                                  %control-TestingStatus        = if_abap_behv=>mk-on
                                   %control-ClientTestingStatus = if_abap_behv=>mk-on
                                    %control-Developer          = if_abap_behv=>mk-on
                                   %control-Finctional          = if_abap_behv=>mk-on
                                  %control-TransportNo          = if_abap_behv=>mk-on
                                  %control-Deployed             = if_abap_behv=>mk-on
                                  %control-Remarks              = if_abap_behv=>mk-on
                                  %control-Stage                = if_abap_behv=>mk-on
                                  %control-FdsStatus            = if_abap_behv=>mk-on
                                  %control-TsdStatus            = if_abap_behv=>mk-on
                                  %control-LastChangedBy        = if_abap_behv=>mk-on
                                  %control-LastChangedAt        = if_abap_behv=>mk-on
                                 %control-LastChangedOn         = if_abap_behv=>mk-on
                                    ) ).
    ENDLOOP.
  ENDMETHOD.
  METHOD updatelog.

   DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    DATA: lv_del TYPE char10.

    READ ENTITIES OF zi_gap_tracker IN LOCAL MODE
         ENTITY  zi_gap_tracker
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    " ---------------------------------------------------------------------
    " ==Save Internal Parameters
    " ---------------------------------------------------------------------
    LOOP AT header ASSIGNING FIELD-SYMBOL(<gfs_header>).

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      <gfs_header>-LastChangedBy         = sy-uname.
      <gfs_header>-LastChangedOn         = lv_date."sy-datum.
      <gfs_header>-LastChangedAt         = lv_time."sy-uzeit.

       MODIFY ENTITIES OF zi_gap_tracker IN LOCAL MODE
              ENTITY zi_gap_tracker
              UPDATE
              FIELDS ( LastChangedBy LastChangedAt LastChangedOn )
              WITH VALUE #( ( %tky                 = <gfs_header>-%tky
                              LastChangedBy = <gfs_header>-LastChangedBy
                              LastChangedAt = <gfs_header>-LastChangedAt
                              LastChangedOn = <gfs_header>-LastChangedOn
                              %control-LastChangedBy        = if_abap_behv=>mk-on
                              %control-LastChangedAt        = if_abap_behv=>mk-on
                              %control-LastChangedOn         = if_abap_behv=>mk-on
                                    ) ).
          endloop.
  ENDMETHOD.

ENDCLASS.
