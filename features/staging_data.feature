Feature: Staging data for serialization

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
    And a domain object is created and populated as:
      """
      class SimpleDomainObjectModel <
          Struct.new(:id, :name, :published, :featured, :owner)
      end
      object = SimpleDomainObjectModel.new(
        55, 'Polygon', true, false, nil
      )
      """
    When a new SonJay model instance is built from domain object data as:
      """
      instance = SimpleJsonObjectModel.assimilate(object)
      """
    Then the instance attributes are as follows:
      | id  | name       | published | featured | owner |
      |  55 |  "Polygon" |  true     |  false   |  nil  |
