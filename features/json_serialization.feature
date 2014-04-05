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
    And a model instance defined as:
      """
      instance = ThingModel.new
      """
    When the instance's property values are assigned as:
      """
      instance.name    = "Cherry"
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
