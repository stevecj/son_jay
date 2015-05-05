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
    When the instance's property values are assigned as:
      """
      instance.rows.additional.concat %w[ X O X ]
      instance.rows.additional.concat %w[ O X X ]
      instance.rows.additional.concat %w[ X O O ]
      """
    And the model is serialized to JSON as:
      """
      json = instance.to_json
      """
    Then the resulting JSON is equivalent to:
      """
      {
        "rows" : [
          [ "X", "O", "X" ] ,
          [ "O", "X", "X" ] ,
          [ "X", "O", "O" ]
        ]
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
    And a model instance defined as:
      """
      instance = TableModel.new
      """
    When the instance's property values are assigned as:
      """
      row_cells = instance.rows.additional
      row_cells.additional.tap{ |c| c.is_head=1 ; c.value='Date'      }
      row_cells.additional.tap{ |c| c.is_head=1 ; c.value='Sightings' }

      row_cells = instance.rows.additional
      row_cells.additional.tap{ |c| c.is_head=1 ; c.value='Jan 1' }
      row_cells.additional.tap{ |c| c.is_head=0 ; c.value=3       }

      row_cells = instance.rows.additional
      row_cells.additional.tap{ |c| c.is_head=1 ; c.value='Jan 3' }
      row_cells.additional.tap{ |c| c.is_head=0 ; c.value=2       }
      """
    And the model is serialized to JSON as:
      """
      json = instance.to_json
      """
    Then the resulting JSON is equivalent to:
      """
      {
        "rows" :
          [
            [ {"is_head": 1, "value": "Date"}  , {"is_head": 1, "value": "Sightings"} ] ,
            [ {"is_head": 1, "value": "Jan 1"} , {"is_head": 0, "value": 3}           ] ,
            [ {"is_head": 1, "value": "Jan 3"} , {"is_head": 0, "value": 2}           ]
          ]
      }
      """

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
    And a model instance defined as:
      """
      instance = SimpleObjectModel.new
      """
    When the instance's property values are assigned as:
      """
      instance['id']        =  55
      instance.name  = "Polygon"
      instance['published'] =  true
      instance['featured']  =  false
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
          "featured"  :  false
      }
      """
