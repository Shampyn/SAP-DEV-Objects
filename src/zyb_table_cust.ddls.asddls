@EndUserText.label: 'custom entity for table elements'
@ObjectModel.query.implementedBy: 'ABAP:ZYB_CL_TABLE_CUST'
define custom entity ZYB_TABLE_CUST
{
  key ABAPObject          : zyb_tabl_name;
      @UI                 : { lineItem:       [ { position: 10, importance: #HIGH, label:'Field' }] ,
             identification: [ { position: 10, label:'Field' } ] }
  key Field               : zyb_field_name;
      @UI                 : { lineItem:       [ { position: 20, importance: #HIGH, label:'Type' }] ,
             identification: [ { position: 20, label:'Type' } ] }
      Type                : zyb_type;
      @UI                 : { lineItem:       [ { position: 30, importance: #HIGH, label:'Length' }] ,
             identification: [ { position: 30, label:'Length' } ] }
      Length              : zyb_length;
      @UI                 : { lineItem:       [ { position: 40, importance: #HIGH, label:'IsKey?' }] ,
            identification: [ { position: 40, label:'IsKey?' } ] }
      KeyField            : zyb_iskey;
      @UI                 : { lineItem:       [ { position: 40, importance: #HIGH, label:'Data Element Description' }] ,
            identification: [ { position: 40, label:'Data Element Description' } ] }
      DataElemDescription : zyb_description;
      @UI                 : { lineItem:       [ { position: 50, importance: #HIGH, label:'Data Element Name' }] ,
            identification: [ { position: 50, label:'Data Element Name' } ] }
      DataElemName        : zyb_dtel_name;


}
