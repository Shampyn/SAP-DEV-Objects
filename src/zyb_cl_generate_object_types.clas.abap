CLASS zyb_cl_generate_object_types DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zyb_cl_generate_object_types IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA lt_object_types TYPE STANDARD TABLE OF zyb_d_object_txt.

    lt_object_types = VALUE #( ( objecttype ='APLO' objecttypetext ='Application Log Object' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='AUTH' objecttypetext ='Authorisation Object' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='CLAS' objecttypetext ='Class' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='BDEF' objecttypetext ='Behavior Definition' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='DCLS' objecttypetext ='Access control' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='DDLS' objecttypetext ='Data definition' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='DDLX' objecttypetext ='Metadata extension' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='DEVC' objecttypetext ='Package' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='DOMA' objecttypetext ='Domain' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='DTEL' objecttypetext ='Data element' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='INTF' objecttypetext ='Interface' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='MSAG' objecttypetext ='Message class' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='SRVD' objecttypetext ='Service Definition' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='SRVB' objecttypetext ='Service Binding' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='TABL' objecttypetext ='Structure/Database table' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='TTYP' objecttypetext ='Table Type' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='VIEW' objecttypetext ='ABAP View' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='STOB' objecttypetext ='CDS View' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='SUSH' objecttypetext ='Default Auth Value' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='CHDO' objecttypetext ='Change Document' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='ENQU' objecttypetext ='Lock Object' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='FUGR' objecttypetext ='Functional Group' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='HTTP' objecttypetext ='HTTP Service' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='OA2S' objecttypetext ='OAuth 2.0 Scope' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='SCO1' objecttypetext ='Communication Scenario' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='SCO2' objecttypetext ='COM Inbound Service' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='SIA1' objecttypetext ='IAM Business Catalog' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='SIA6' objecttypetext ='IAM App' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='SIA7' objecttypetext ='IAM App to Catalog Assignment' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='XSLT' objecttypetext ='XSL Transformation' hidden_flag ='' sorted_by_number ='0'  )
                               ( objecttype ='APIS' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='IWMO' objecttypetext ='Unknown Type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='G4BA' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='IWOM' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='IWSG' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='IWSV' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='IWVB' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='NROB' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='SAJC' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='SAJT' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='WAPA' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='UIAD' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='SUSO' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='SRVC' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='SMIM' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='SMBC' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='SIA2' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='SICF' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='SIA5' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                               ( objecttype ='SIA3' objecttypetext ='Unknown type' hidden_flag ='X' sorted_by_number ='100'  )
                             ).

    MODIFY zyb_d_object_txt FROM TABLE @lt_object_types.

    IF sy-subrc = 0.
      out->write( 'Data were populated into ZYB_D_OBJECT_TXT DB table' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
