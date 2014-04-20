Feature: Staging data for serialization

  Scenario: Simple object data
    Given a SonJay object model defined as:
      """
      class SimpleSonjObjectModel < SonJay::ObjectModel
        properties do
          property :id
          property :name
          property :published
          property :featured
          property :owner
        end
      end
      """
    And a domain object created and populated as:
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
      instance = SimpleSonjObjectModel.assimilate(object)
      """
    Then the instance attributes are as follows:
      | id  | name       | published | featured | owner |
      |  55 |  "Polygon" |  true     |  false   |  nil  |

  Scenario: Composite object data
    Given an object model defined as:
      """
      class ThingSonjModel < SonJay::ObjectModel
        properties do
          property :name
          property :details, :model => DetailSonjModel
        end
      end
      """
    And an object model defined as:
      """
      class DetailSonjModel < SonJay::ObjectModel
        properties do
          property :color
          property :size
        end
      end
      """
    And a domain object created and populated as:
      """
      class ThingObjectModel <
          Struct.new(:name, :details)
      end
      class DetailObjectModel <
          Struct.new(:color, :size)
      end
      object = ThingObjectModel.new(
        "Cherry",
        DetailObjectModel.new("red", "small")
      )
      """
    When a new SonJay model instance is built from domain object data as:
      """
      instance = ThingSonjModel.assimilate(object)
      """
    Then the instance attributes are as follows:
      | name      | details.color | details.size |
      |  "Cherry" |  "red"        |  "small"     |
