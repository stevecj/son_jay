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
  @wip
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
