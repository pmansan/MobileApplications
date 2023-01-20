# Cloud Diver Design Document
This document is a design proposal for **Cloud Diver**, a *'Videogame Design & Programming'* game design project (2022).

> **Contents**
> 1. Team
> 2. Game Concept
> 3. Development objectives (Scope)

## 1. Team 
Our team consists of 6 members:
- Cin Yie Chang [Project Leader/Designer]
- Javi Arroyo García [role/Developer]
- Filip Pagliaro [Github Manager/Developer]
- Jorge Parra [Artist/Developer]
- Constantinos Savvidis [role/Developer]
- Paula Mandingorra  [Artist/Developer]


### Collaboration
- File sharing & Project management: GitHub
- Brainstorm & Design: Miro, Real life
- Communication: WhatsApp
- Prototype sharing: itch.co

## 2. Game concept
Based upon the original game concept document.

#### 2.1 Introduction
Cloud Diver is a mobile endless runner game that takes the player through eye-catching, dreamy scenes. Perfect for everyone - your father, your sister, even your grandmother!

> **Background (Inspiration)**
> The inspiration for the theme came from the creator's love for clouds, sunsets and colored skies in general. 

> **Vision statement:** A family friendly mobile game, that is intuitive and addicting (and visually eye-catching).

#### 2.2 Description
- Goal: The goal of the game is pretty straight-forward: Improve your highscore. You have to avoid obstacles in order to proceed and stay alive as long as possible. Hit an obstacle (or something related), you fall down and it is game over.  
- Player: Somehow you can jump on clouds. Maybe it is a dream, maybe you are a superhero, maybe you escape from a skyscraper fire - the story still needs work. To play, you simply have to tap the screen in order to jump. The screen is held horizontally.
- Scenery/Art: Eye-catching, but simple 2D skies. The scenery changes with how far you get into the game. As time goes by, the sky would consequently get more colorful and eventually black with stars. Additionally some element could be added that counts the days, if you reach that expert status. 
- Potential obstacles: Birds, planes, weather (rain/thunder), fictional creatures
- Potential power-ups: Rainbows, superheroes, stars, UFOs, fictional creatures

#### 2.3 Key Features (USPs)
- Endless runner games have proven to be an effective dopamine creator.
- Eye-catching, colorful and dreamy original art.
- Funny, creative power-ups and obstacles.
- Driven by an algorithm that generates the clouds, making every play unique (no fixed levels). 

#### 2.4 Market Analysis
The gameplay is similar to that of viral games like Flappy Bird, Jetpack Joyride, Temple Run and Subway Surfers, which have proven that the instant satisfaction of endless runner games are a great strategy. What makes this endless runner stand out from the mentioned examples, is it's dreamy and perhaps feminine approach to the game. Cute but simple art styles have proven to be effective in other, non-endless runner mobile games (Dadish, Turnip Boy Commits Tax Evasion, Super Fowlst). 

#### 2.5 Platform(s)
Primarily this would be availbale on mobile, given the target and required controls (tapping/clicking). The game could alternatively be modified for PC, but other consoles seem like an over-kill. Additionally, this would be a casual game, which makes mobile logical since it could be played whenever wherever (incl. in public).

## 3. Technical Definitions
- Aspect ratio: 16:9
- Pixel resolution for art: 192x108
- Pixels per Unity unit 16:1
- Unity camera size 3

## 4 Object sizes (Unity units)
- Full level 12 x 6.75
- Character size: 1 x 1.5
- Cloud widths 1.5, 2, 2.5
- Cloud height 1
- Flying 0.5 x 0.5
- Score counter 3 x 1
- Pause button 1 x 1

## 5. Development objectives (Scope)

### Main features / Must-haves
> **Play**
> - Main mechanic: Player can jump on generated platforms.
> - Highscore tracking 

> **Interface**
> - Start screen
> - Pause menu 
> - Restart screen (Play again)
> - Includes titles and buttons

> **Graphics**
> - Graphic (sprite) for every visible element in the game: character, obstacles.
> - Background: at least 2 styles/environments

> **Sound**
> - Action sounds of main character: Jump, Tap button
> - Background music
> - Event: Game-over, New Highscore.

### Extra features / Nice-to-haves
> **Play**
> - Subtle shifts in play method (levels) - e.g. inverted actions (avoid clouds instead of jumping on them)
> - More abilities (special jump)
> - Quests / challenges
> - Easter eggs
> - Power ups :)

> **Interface**
> - Start screen: Animated logo
> - Setting menu: custom settings - e.g. sounds, control settings, personal avatar

> **Graphics**
> - Glow effect
> - Motion blur
> - Background: more styles/environment
> - Transitions

> **Sound**
> - Action sounds: Obstacles/enemies, Background ambient sounds (e.g. birds), Special jump sound(?)
> - Background music: different tunes for different environments
> - Event: Transitions, starting screen
