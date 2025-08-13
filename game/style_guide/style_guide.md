## Godot 4.4 GDScript Style Guide - Compact Reference

### **File Structure & Encoding**
- Use UTF-8 encoding, LF line breaks, one LF at file end
- File names: `snake_case` (e.g., `yaml_parser.gd`)
- Use tabs for indentation (not spaces)

### **Code Organization Order**
```gdscript
# 1. Annotations
@tool
@icon("path")
@static_unload

# 2. Class declaration
class_name MyClass
extends BaseClass
## Documentation comment

# 3. Signals
signal my_signal(param)

# 4. Enums
enum MyEnum { VALUE_A, VALUE_B }

# 5. Constants
const MAX_VALUE = 100

# 6. Static variables
static var static_var = 0

# 7. Export variables
@export var exported_var: int = 5

# 8. Regular variables
var regular_var: String = ""
var _private_var: int = 0

# 9. Onready variables
@onready var node_ref: Node = get_node("Path")

# 10. Methods (in order)
# - _static_init()
# - static methods
# - _init()
# - _enter_tree()
# - _ready()
# - _process()/_physics_process()
# - other virtual methods
# - public methods
# - private methods
# - subclasses
```

### **Naming Conventions**
| Type | Convention | Example |
|------|------------|---------|
| Files | snake_case | `player_controller.gd` |
| Classes | PascalCase | `class_name PlayerController` |
| Nodes | PascalCase | `PlayerNode`, `Camera3D` |
| Functions | snake_case | `func move_player():` |
| Variables | snake_case | `var health_points = 100` |
| Private vars/funcs | _snake_case | `var _internal_state`, `func _update():` |
| Signals | snake_case (past tense) | `signal door_opened`, `signal health_changed` |
| Constants | CONSTANT_CASE | `const MAX_HEALTH = 100` |
| Enums | PascalCase | `enum Direction` |
| Enum members | CONSTANT_CASE | `{UP, DOWN, LEFT, RIGHT}` |

### **Formatting Rules**

**Indentation:**
- 1 tab per level for code blocks
- 2 tabs for continuation lines (except arrays/dicts/enums use 1 tab)

**Spacing:**
- One space around operators: `x = 5`, `if x > 0:`
- One space after commas: `func test(a, b, c):`
- No extra spaces in brackets: `dict["key"]`, `func(param)`
- Single-line dicts: `{ key = "value" }` (spaces inside braces)

**Line Length:**
- Keep under 100 characters (prefer 80)
- One statement per line (except ternary operator)

**Blank Lines:**
- 2 blank lines around functions and classes
- 1 blank line inside functions for logical separation

**Boolean Operators:**
- Use `and`, `or`, `not` (not `&&`, `||`, `!`)

**Quotes:**
- Prefer double quotes: `"hello world"`
- Use single quotes to avoid escapes: `'hello "world"'`

**Numbers:**
- Include leading/trailing zeros: `0.5`, `13.0` (not `.5`, `13.`)
- Lowercase hex: `0xfb8c0b`
- Use underscores for large numbers: `1_234_567`

### **Multiline Formatting**
```gdscript
# Continuation lines (2 tabs)
long_function_call(param1, param2,
		param3, param4)

# Arrays/Dicts/Enums (1 tab + trailing comma)
var array = [
	"item1",
	"item2",
	"item3",
]

var dict = {
	"key1": "value1",
	"key2": "value2",
}

# Multiline conditions
if (
		condition1 and condition2
		and condition3
):
	pass

# Multiline ternary
var result = (
		"value1" if condition1
		else "value2" if condition2
		else "default"
)
```

### **Type Hints**
```gdscript
# Explicit types when ambiguous
var health: int = 0
func heal(amount: int) -> void:

# Inferred types when clear
var direction := Vector3(1, 2, 3)

# Required for node references
@onready var ui: Control = get_node("UI")
# OR
@onready var ui := get_node("UI") as Control
```

### **Comments**
- Use `# ` (space after hash) for comments
- Use `##` for documentation
- Use `#region`/`#endregion` (no space) for folding
- No space when commenting out code: `#print("debug")`