Feature: Unloading data after parsing

  Scenario: Simple object data
    Given a SonJay object model defined as:
      """
      class SimpleJsonObjectModel < SonJay::ObjectModel
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
      instance = SimpleJsonObjectModel.new
      """
    And a domain object created as:
      """
      class SimpleDomainObjectModel <
          Struct.new(:id, :name, :published, :featured, :owner)
      end
      object = SimpleDomainObjectModel.new
      """
    When the instance's property values are assigned as:
      """
      instance.id        =  55
      instance.name      = "Polygon"
      instance.published =  true
      instance.featured  =  false
      instance.owner     =  nil
      """
    And data is disseminated to the domain object as:
      """
      instance.sonj_content.disseminate_to object
      """
    Then the domain object attributes are as follows:
      | id  | name       | published | featured | owner |
      |  55 |  "Polygon" |  true     |  false   |  nil  |
