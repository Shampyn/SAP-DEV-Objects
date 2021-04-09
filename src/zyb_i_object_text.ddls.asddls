@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Object Type Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@UI: {
  headerInfo: {
    typeName: 'Object Type',
    typeNamePlural: 'Object Types',
    title: {
      type: #STANDARD,
      value: 'Objecttype'
    },
    description: {
      type: #STANDARD,
      value: 'Objecttypetext'
    }
  }
}

define root view entity ZYB_I_OBJECT_TEXT
  as select from zyb_d_object_txt
{
      @UI.facet: [
        {
          id:       'General_Info',
          purpose:  #STANDARD,
          type:     #IDENTIFICATION_REFERENCE,
          label:    'General Info',
          position: 10
        }
      ]

      @UI: {
        lineItem: [ { position: 10, importance: #HIGH }],
        identification: [ { position: 10 } ],
        selectionField: [ { position: 10 } ]
      }
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZYB_I_OBJECT_TYPE_VH', element: 'ABAPObjectType'  } } ]
      @EndUserText.label: 'Object Type'
  key objecttype       as Objecttype,

      @UI: {
        lineItem: [ { position: 20, importance: #HIGH }] ,
        identification: [ { position: 20 } ],
        selectionField: [ { position: 20 } ]
      }
      @Semantics.text: true
      @EndUserText.label: 'Object Type Text'
      objecttypetext   as Objecttypetext,

      @UI: {
        lineItem: [ { position: 30, importance: #HIGH }] ,
        identification: [ { position: 30 } ],
        selectionField: [ { position: 30 } ]
      }
      @Consumption.filter: {
        selectionType: #SINGLE
      }
      hidden_flag      as HiddenFlag,

      @UI: {
        lineItem: [ { position: 40, importance: #HIGH }] ,
        identification: [ { position: 40 } ],
        selectionField: [ { position: 40 } ]
      }
      sorted_by_number as SortedByNumber
}
