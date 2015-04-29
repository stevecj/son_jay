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
      instance = SimpleObjectModel.parse_json( json )
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
      instance = ThingModel.parse_json( json )
      """
    Then the instance attributes are as follows:
      | name      | details.color | details.size |
      |  "Cherry" |  "red"        |  "small"     |

  Scenario: Object data with a value-array property
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
      instance = ContestantModel.parse_json( json )
      """
    Then the instance attributes are as follows:
      | name   | scores[0] | scores[1] | scores[2] |
      |  "Pat" |  9        |  5        |  7        |

  Scenario: Object data with a nested value-array property
    Given an object model defined as:
      """
      class TicTacToeModel < SonJay::ObjectModel
        properties do
          property :rows, model: [[]]
        end
      end
      """
    And a model instance defined as:
      """
      instance = TicTacToeModel.new
      """
    And JSON data defined as:
      """
      json = <<-JSON
        {
          "rows" : [
            [ "X", "O", "X" ] ,
            [ "O", "X", "X" ] ,
            [ "X", "O", "O" ]
          ]
        }
      JSON
      """
    When the JSON is parsed to a model instance as:
      """
      instance = TicTacToeModel.parse_json( json )
      """
    Then the instance attributes are as follows:
      | rows[0][0]   | rows[0][1] | rows[0][2] |
      |  'X'         |  'O'       |  'X'       |
      | rows[1][0]   | rows[1][1] | rows[1][2] |
      |  'O'         |  'X'       |  'X'       |
      | rows[2][0]   | rows[2][1] | rows[2][2] |
      |  'X'         |  'O'       |  'O'       |

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
      instance = ListModel.parse_json( json )
      """
    Then the instance attributes are as follows:
      | name        | items[0].description | items[0].priority | items[1].description | items[1].priority |
      |  "Shopping" |  "Potato Chips"      |  "Low"            |  "Ice Cream"         |  "High"           |

  Scenario: Object data with a nested object-array property
    Given an object model defined as:
      """
      class TableModel < SonJay::ObjectModel
        properties do
          property :rows, :model => [[ CellModel ]]
        end
      end
      """
    And an object model defined as:
      """
      class CellModel < SonJay::ObjectModel
        properties do
          property :is_head
          property :value
        end
      end
      """
    And JSON data defined as:
      """
      json = <<-JSON
      {
        "rows" :
          [
            [ {"is_head": 1, "value": "Date"}  , {"is_head": 1, "value": "Sightings"} ] ,
            [ {"is_head": 1, "value": "Jan 1"} , {"is_head": 0, "value": 3}           ] ,
            [ {"is_head": 1, "value": "Jan 3"} , {"is_head": 0, "value": 2}           ]
          ]
      }
      JSON
      """
    When the JSON is parsed to a model instance as:
      """
      instance = TableModel.parse_json( json )
      """
    Then the instance attributes are as follows:
      | rows[0][0].is_head | rows[0][0].value | rows[0][1].is_head | rows[0][1].value |
      |  1                 |  "Date"          |  1                 |  "Sightings"     |
      | rows[1][0].is_head | rows[1][0].value | rows[1][1].is_head | rows[1][1].value |
      |  1                 |  "Jan 1"         |  0                 |  3               |
      | rows[2][0].is_head | rows[2][0].value | rows[2][1].is_head | rows[2][1].value |
      |  1                 |  "Jan 3"         |  0                 |  2               |

  Scenario: Object data with extra properties
    Given an object model defined as:
      """
      class SimpleObjectModel < SonJay::ObjectModel
        allow_extras

        properties do
          property :id
          property :name
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
            "featured"  :  false
        }
      JSON
      """
    When the JSON is parsed to a model instance as:
      """
      instance = SimpleObjectModel.parse_json( json )
      """
    Then the instance attributes and indexed properties are as follows:
      | id  | name       | ['published'] | ['featured'] |
      |  55 |  "Polygon" |  true         |  false       |
