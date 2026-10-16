 TYPES:
      BEGIN OF ty_cpm_payload,
            SalesContDt     TYPE string,
            Plant           TYPE string,
            CustPONo        TYPE string,
            CustPODt        TYPE string,
            CustCode        TYPE string,
            MatCode         TYPE string,
            MatName         TYPE string,
            ItemSetCode     TYPE string,
            CustDescAsPerPO TYPE string,
            MatByCustomerSC TYPE string,
            MatByCustomerMI TYPE string,
      END OF ty_cpm_payload.


TYPES: BEGIN OF ty_sub_response,
           error    TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
       END OF ty_sub_response.

    TYPES:
      BEGIN OF ty_response,
        message            TYPE string,
        status             TYPE string,
        data               TYPE ty_sub_response,
      END OF ty_response.
