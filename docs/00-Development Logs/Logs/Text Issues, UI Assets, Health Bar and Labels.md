### Tasks Completed
- The text issue seems to be tied to the viewport size which I won't be changing. Likely wont be an issue once I get a legit pixel font to use. Since I'll likely be making my own font I'll need to consider the viewport size when choosing a canvas to avoid issues.
- Found a GD Script linter extension in VS Code, so I refactored all files again to follow the [Godot style guide](https://docs.godotengine.org/en/4.4/tutorials/scripting/gdscript/gdscript_styleguide.html) appropriately
- Found some good UI assets on [itch.io](https://finnmercury.itch.io/ultimate-dark-fantasy-ui-v20) for Player and Boss health bars
	- Will build on top of them for the final product
- Edited one of the sprites to use for the player health bar
	- Learned how to use the TextureProgressBar to allow the health to grow from the center of the bar
	- Also setup the health bar to expand horizontally on max health upgrades
	- To manage this I edited the health bar and all health changes to be equal numbers to avoid subpixel issues. Still experiencing some 'shaking' on expansion, but can't seem to figure it out yet.
- Fixed up the labels being created for open chests and interacting with NPCs to be a modular scene as opposed to being created programmatically
### Resources Used
- None
### Next Session Notes
- 
### Date
- August 24, 2025