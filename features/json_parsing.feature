Feature: Parsing data from JSON

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
    And JSON data defined as:
      """
      json = <<-JSON
        {
            "id"        :  55 ,
            "name"      : "Polygon" ,
            "published" :  true ,
            "featured"  :  false ,
            "owner"     :  null
        }
      JSON
      """
    When the JSON is parsed to a model instance as:
      """
      instance = SimpleObjectModel.json_create( json )
      """
    Then the instance attributes are as follows:
      | id  | name       | published | featured | owner |
      |  55 |  "Polygon" |  true     |  false   |  nil  |

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
    And JSON data defined as:
      """
      json = <<-JSON
        {
            "name" :  "Cherry" ,
            "details" :
              {
                "color" : "red" ,
                "size"  : "small"
              }
        }
      JSON
      """
    When the JSON is parsed to a model instance as:
      """
      instance = ThingModel.json_create( json )
      """
    Then the instance attributes are as follows:
      | name      | details.color | details.size |
      |  "Cherry" |  "red"        |  "small"     |

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
    And JSON data defined as:
      """
      json = <<-JSON
        {
            "name"   : "Pat" ,
            "scores" : [ 9, 5, 7 ]
        }
      JSON
      """
    When the JSON is parsed to a model instance as:
      """
      instance = ContestantModel.json_create( json )
      """
    Then the instance attributes are as follows:
      | name   | scores[0] | scores[1] | scores[2] |
      |  "Pat" |  9        |  5        |  7        |

  @wip
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
    And JSON data defined as:
      """
      json = <<-JSON
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
      JSON
      """
    When the JSON is parsed to a model instance as:
      """
      instance = ListModel.json_create( json )
      """
    Then the instance attributes are as follows:
      | name        | items[0].description | items[0].priority | items[1].description | items[0].priority |
      |  "Shopping" |  "Potato Chips       |  "Low"            |  "Ice Cream"         |  "High"           |
