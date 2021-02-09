@EndUserText.label: 'message class custom'
@ObjectModel.query.implementedBy: 'ABAP:ZYB_CL_MSAG_CUST'
define custom entity ZYB_MSAG_CUST
{
  key ClassName : zyb_msag_class_name;
      @UI       : { lineItem:       [ { position: 10, importance: #HIGH, label:'Number' }] ,
                            identification: [ { position: 10, label:'Number' } ] }
  key MSGnumber : zyb_msag_number;
      @UI       : { lineItem:       [ { position: 20, importance: #HIGH, label:'Message' }] ,
                            identification: [ { position: 20, label:'Message' } ] }
      message   : zyb_message;


}
