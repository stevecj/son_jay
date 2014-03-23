Feature: Parsing JSON

  Scenario: Simple object data
    Given an object model defined as:
      """
      class SimpleObjectModel < SonJay::ObjectModel
        property :id
        property :name
        property :published
        property :featured
        property :owner
      end
      """
    And a JSON string defined as:
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
    When the JSON is parsed to an object model instance as:
      """
      instance = SimpleObjectModel.json_create(json)
      """
    Then the instance property values are:
      | id  | name      | published | featured | owner |
      |  55 | "Polygon" |  true     |  false   |  nil  |

  Scenario: Composite object data
    Given an object model defined as:
      """
      class CompositeObjectModel < SonJay::ObjectModel
        property :ubername
        property :component, object_model: ->{ ComponentObjectModel }
      end
      """
    And an object model defined as:
      """
      class ComponentObjectModel < SonJay::ObjectModel
        property :undername
      end
      """
    And a JSON string defined as:
      """
      json = <<-JSON
      {
          "ubername"  : "Uber!",
          "component" :
              {
                  "undername" : "(under)"
              }
      }
      JSON
      """
    When the JSON is parsed to an object model instance as:
      """
      instance = CompositeObjectModel.json_create(json)
      """
    Then the instance property values are:
      | ubername | component.undername |
      |  "Uber!" |  "(under)"          |

  Scenario: Value array data
    Given a JSON string defined as:
      """
      json = <<-JSON
      [
          "abc",
          1,
          null,
          true
      ]
      JSON
      """
    When the JSON is parsed to a value array model instance as:
      """
      instance = SonJay::ValueArrayModel.json_create(json)
      """
    Then the instance has an entries sequencce of:
      |  "abc"  |  1  |  nil  |  true  |
