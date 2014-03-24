Feature: Serializing data to JSON

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
    And a model instance constructed as:
      """
      instance = SimpleObjectModel.new
      """
    When instance property values are assigned as:
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
    And a model instance constructed as:
      """
      instance = CompositeObjectModel.new
      """
    When instance property values are assigned as:
      """
      instance.ubername = 'Uber!'
      instance.component.undername = '(under)'
      """
    And the model is serialized to JSON as:
      """
      json = instance.to_json
      """
    Then the resulting JSON is equivalent to:
      """
      {
          "ubername"  : "Uber!",
          "component" :
              {
                  "undername" : "(under)"
              }
      }
      """

  Scenario: Value array data
    Given a model instance constructed as:
      """
      instance = SonJay::ValueArrayModel.new
      """
    When instance elements are added as:
      """
      instance << 1
      instance.unshift 'abc'
      instance.concat( [nil, true] )
      """
    And the model is serialized to JSON as:
      """
      json = instance.to_json
      """
    Then the resulting JSON is equivalent to:
      """
      [
          "abc",
          1,
          null,
          true
      ]
      """

  Scenario: Object array data
    Given an object model defined as:
      """
      class MyObjectModel < SonJay::ObjectModel
        property :id
        property :name
      end
      """
    And an object array model instance constructed as:
      """
      instance = MyObjectModel * 2
      """
    When instance element values are assigned as:
      """
      obj = instance.first
      obj.id = 1
      obj.name = 'One'

      obj = instance[1]
      obj.id = 2
      obj.name = 'Two'

      obj = instance.push!
      obj.id = 3
      obj.name = 'Three'
      """
    And the model is serialized to JSON as:
      """
      json = instance.to_json
      """
    Then the resulting JSON is equivalent to:
      """
      [
        {
            "id"   :  1 ,
            "name" : "One"
        }, {
            "id"   :  2 ,
            "name" : "Two"
        }, {
            "id"   :  3 ,
            "name" : "Three"
        }
      ]
      """
