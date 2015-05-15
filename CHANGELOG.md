### 0.5.0
* Enhancements
  * Allow subclassing/extending model classes
  * Access content of model instances using #model_content
    instead of #sonj_content
  * Implement well-behaved #freeze, #dup, and #clone for model
    instances
  * Expose additional Array/Enumerable behavior for model-array
    instances
  * Implement #to_a for model-array instances
  * Implement #to_h for object-model instances

### 0.4.1
* Enhancements
  * Add this CHANGELOG.md file
  * Made feature scenarios more informative regarding bracket
    operator behavior for defined properties when extra
    properties are allowed.
* Bugs fixed
  * Incorrect writing/reading of defined object-model properties
    using index operators when extra properties are allowed.

### 0.4.0
* Last version without a change-log
