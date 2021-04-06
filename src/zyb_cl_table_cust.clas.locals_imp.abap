CLASS lcx_rap_query_provider DEFINITION
  INHERITING FROM cx_rap_query_provider
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor IMPORTING !textid   LIKE if_t100_message=>t100key OPTIONAL
                                  !previous LIKE previous OPTIONAL .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcx_rap_query_provider IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
