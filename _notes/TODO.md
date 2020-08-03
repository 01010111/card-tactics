# Broad Strokes

- [x] Movement
- [x] Mutant Gear
- [x] Gear Pickups
- [x] Props
- [ ] Pickups
- [ ] Turns
- [ ] Enemies

# Small Things

- [ ] Mutant Gear Content
  - [ ] Create new mutant gears
  - [ ] Implement events

- [ ] Props
  - [ ] Make more props

- [ ] Audio
  - [ ] Learn OpenFL audio best practices
  - [ ] Implement some audio for UI

- [ ] Loot
  - [ ] Create a system for populating loot per level


# Bugs

- [ ] Sometimes ColorShader doesn't respond to uMix

# Completed

8/3/2020
- [x] Make resizeable
  - [x] Update UI on resize
  - [x] Show warning on window that is too small

7/16/2020
- [x] Sort objects in Level
- [x] Loot
  - [x] Figure out what a loot table is
  - [x] Create one
- [x] Pickups 
  - [x] Make more pickups
    - [x] Monster Meat
    - [x] Shields

7/15/2020
- [x] Gear Pickups
  - [x] Create UI for placing new Gear
  - [x] Interaction for (re)placing gear
- [x] Better gear placement UX
  - [x] Cancel button
  - [x] Hide Move Equipment
- [x] Automatically move html5/bin/ to docs/
- [x] Refactor Game State members to unified state
- [x] Fix gear mouseover not showing range

7/14/2020
- [x] Camera effects
  - [x] ColorShader
  - [x] Dolly.flash()
- [x] Props
  - [x] Create destructable box
  - [x] Implement kill()

7/7/2020
- [x] Refactor Equipment
  - [x] Data first
  - [x] Generate Sprites from data

7/6/2020
- [x] Move Card
  - [x] Cards not counted as played
  - [x] Cards are movable after played

7/2/2020
- [x] Info
  - [x] Create Info Window
  - [x] Create Util for adding info on hover on objects
- [x] After gear is disabled, if previously active, handle can still be used to carry out action

6/29/2020
- [x] Pickups
  - [x] Create clickable object
- [x] Turns
  - [x] Remove player interactions during enemy turn

6/27/2020
- [x] Make uniforms work in Shaders
- [x] Mutant cards invisible when expended shader applied
- [x] Text not showing in Windows build

6/19/2020
- [x] Make Outline Shader smooth

6/18/2020
- [x] Mutant Gear Implementation
  - [x] Drawing new card Type
  - [x] Event system

6/17/2020
- [x] Implement translations
  - [x] Make Spreadsheet
  - [x] Implement look up map
- [x] Refactor Gear -> Equipment
  - [x] Gear -> Equipment
  - [x] Create EquipmentCard
  - [x] Extend Equipment->GearCard

6/16/2020
- [x] Shields
  - [x] Artwork
  - [x] Implementation
- [x] Show object attack range

6/15/2020
- [x] Mutant Gear Artwork
  - [x] Layout
  - [x] Illustration

6/14/2020
- [x] Camera
  - [x] Shake
  - [x] Panning
    - [x] On Level Drag
    - [x] On WASD

6/12/2020
- [x] Range Restrictions
  - [x] Rook
  - [x] Bishop

6/11/2020
- [x] Move Cards
  - [x] Show Available Moves
    - [x] Similar to Actionable Gear
    - [x] Persistent per player
  - [x] Click on Available Moves to Move
    - [x] Gray Out Move Card

6/5/2020
- [x] Drop Playing Cards on Move Card
  - [x] Check for prox to Move Card
  - [X] Validate against Move Data

6/4/2020
- [x] Refactor GearCard
  - [x] Make Generic DropCard

6/3/2020

- [x] Work on Player Info
  - [x] Show Player Avatar (placeholder)
    - [x] Switch Players on click
  - [x] Show Player AP
  - [x] Show Player HP
  - [x] Show Move Card