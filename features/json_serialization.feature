Feature: Serializing data to JSON

  Scenario: Simple object data
    Given an object model defined as:
      """
      class SimpleObjectModel < SonJay::ObjectModel
        properties do
          property :id
          property :name
          property :published
          property :featured
          property :owner
        end
      end
      """
    And a model instance defined as:
      """
      instance = SimpleObjectModel.new
      """
    When the instance's property values are assigned as:
      """
      instance.id        =  55
      instance.name      = "Polygon"
      instance.published =  true
      instance.featured  =  false
      instance.owner     =  nil
      """
    And the model is serialized to JSON as:
      """
      json = instance.to_json
      """
    Then the resulting JSON is equivalent to:
      """
      {
          "id"        :  55 ,
          "name"      : "Polygon" ,
          "published" :  true ,
          "featured"  :  false ,
          "owner"     :  null
      }
      """

  Scenario: Composite object data
    Given an object model defined as:
      """
      class ThingModel < SonJay::ObjectModel
        properties do
          property :name
          property :details, :model => DetailModel
        end
      end
      """
    And an object model defined as:
      """
      class DetailModel < SonJay::ObjectModel
        properties do
          property :color
          property :size
        end
      end
      """
    And a model instance defined as:
      """
      instance = ThingModel.new
      """
    When the instance's property values are assigned as:
      """
      instance.name = "Cherry"
      instance.details.color = "red"
      instance.details.size  = "small"
      """
    And the model is serialized to JSON as:
      """
      json = instance.to_json
      """
    Then the resulting JSON is equivalent to:
      """
      {
          "name" :  "Cherry" ,
          "details" :
            {
              "color" : "red" ,
              "size"  : "small"
            }
      }
      """

  Scenario: Object data with an value-array property
    Given an object model defined as:
      """
      class ContestantModel < SonJay::ObjectModel
        properties do
          property :name
          property :scores, model: []
        end
      end
      """
    And a model instance defined as:
      """
      instance = ContestantModel.new
      """
    When the instance's property values are assigned as:
      """
      instance.name   = "Pat"
      instance.scores = [ 9, 5, 7 ]
      """
    And the model is serialized to JSON as:
      """
      json = instance.to_json
      """
    Then the resulting JSON is equivalent to:
      """
      {
          "name"   : "Pat" ,
          "scores" : [ 9, 5, 7 ]
      }
      """

  Scenario: Object data with an object-array property
    Given an object model defined as:
      """
      class ListModel < SonJay::ObjectModel
        properties do
          property :name
          property :items, :model => [ ItemModel ]
        end
      end
      """
    And an object model defined as:
      """
      class ItemModel < SonJay::ObjectModel
        properties do
          property :description
          property :priority
        end
      end
      """
    And a model instance defined as:
      """
      instance = ListModel.new
      """
    When the instance's property values are assigned as:
      """
      instance.name = "Shopping"

      item = instance.items.additional
      item.description = 'Potato Chips'
      item.priority    = 'Low'

      item = instance.items.additional
      item.description = 'Ice Cream'
      item.priority    = 'High'
      """
    And the model is serialized to JSON as:
      """
      json = instance.to_json
      """
    Then the resulting JSON is equivalent to:
      """
      {
        "name" :  "Shopping" ,
        "items" :
          [
            {
              "description" : "Potato Chips" ,
              "priority"    : "Low"
            } ,
            {
              "description" : "Ice Cream" ,
              "priority"    : "High"
            }
          ]
      }
      """
