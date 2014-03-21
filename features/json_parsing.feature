Feature: Parsing JSON

  @wip
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
