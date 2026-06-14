# Android Testing

## Manual checklist

1. Open the project in Godot 4.6 Android Editor.
2. Run the main scene.
3. Confirm landscape orientation.
4. Confirm the HUD stays compact and does not cover the playable area.
5. Confirm the virtual joystick moves the player.
6. Confirm collisions with cliffs and rubble.
7. Confirm the camera follows the player.
8. Confirm the attack button damages the training dummy.
9. Confirm the ash mite damages the player.
10. Confirm dodge consumes stamina.
11. Confirm stamina regenerates.
12. Confirm checkpoint activation restores health.
13. Confirm the pause menu opens.
14. Confirm dialogue opens near `Тесса`.
15. Confirm the journal shows the quest title and current objective.
16. Confirm pixel art stays sharp without blurry scaling.
17. Confirm there are no severe frame drops.
18. Capture screenshots and logs for follow-up work.

## Notes

- Keep touch controls clear of common Android gesture zones.
- Preserve Russian visible UI text in menus and prompts.
- Use the Android device viewport to judge HUD spacing, not only the editor window.
