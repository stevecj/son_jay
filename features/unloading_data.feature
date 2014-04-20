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

  @wip
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
    And a model instance defined as:
      """
      instance = ThingSonjModel.new
      """
    When the instance's property values are assigned as:
      """
      instance.name = "Cherry"
      instance.details.color = "red"
      instance.details.size  = "small"
      """
    And a domain object created as:
      """
      class ThingObjectModel <
          Struct.new(:name, :details)
      end
      class DetailObjectModel <
          Struct.new(:color, :size)
      end
      object = ThingSonjModel.new
      """
    And data is disseminated to the domain object as:
      """
      instance.sonj_content.disseminate_to object, {
        property_mappings: {
          details: {
            class:      DetailObjectModel,
            value_args: [:color, :size],
          }
        }
      }
      """
    Then the domain object attributes are as follows:
      | name      | details.color | details.size |
      |  "Cherry" |  "red"        |  "small"     |
