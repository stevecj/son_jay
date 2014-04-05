Feature: Parsing data from JSON

  @wip
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
      instance = SimpleObjectModel.json_create
      """
    Then the instance attributes are as follows:
      | id  | name       | published | featured | owner |
      |  55 |  "Polygon" |  true     |  false   |  nil  |
