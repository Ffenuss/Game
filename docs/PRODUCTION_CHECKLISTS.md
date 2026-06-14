# Production Checklists

Практические чеклисты для будущих задач.

## 1. New feature checklist

- [ ] Feature is needed in current scope.
- [ ] Gameplay impact is clear.
- [ ] Owner scene/script is known.
- [ ] Inputs are documented.
- [ ] Feedback is visible to player.
- [ ] Android risk is acceptable.
- [ ] Validation path exists.
- [ ] Docs will be updated.

## 2. New scene checklist

- [ ] Scene has one clear responsibility.
- [ ] It is reusable.
- [ ] No hard dependency on unrelated systems.
- [ ] Asset paths are stable.
- [ ] Scene loads without missing refs.
- [ ] The scene is named clearly.

## 3. New script checklist

- [ ] Script has one responsibility.
- [ ] Typed where practical.
- [ ] No giant manager behavior.
- [ ] Uses signals when helpful.
- [ ] Does not hard-code raw asset paths.
- [ ] Has a validation route.

## 4. New asset checklist

- [ ] License is green or approved.
- [ ] Source page is stable.
- [ ] Proof is archived.
- [ ] Hashes are recorded.
- [ ] Manifest updated.
- [ ] Credits updated if needed.
- [ ] Runtime path is canonical.

## 5. New enemy checklist

- [ ] Silhouette is readable.
- [ ] Movement is lightweight.
- [ ] Attack telegraph exists.
- [ ] Damage response exists.
- [ ] Death is safe.
- [ ] Can be tested on Android controls.

## 6. New NPC checklist

- [ ] NPC name is clear in Russian.
- [ ] Dialogue is readable.
- [ ] Interaction prompt exists.
- [ ] Quest flow does not hard-lock the player.
- [ ] Missing data fails safe.

## 7. New quest checklist

- [ ] Quest title is readable.
- [ ] Current objective is obvious.
- [ ] Journal updates correctly.
- [ ] Quest update notification exists.
- [ ] Missing quest data does not crash the game.

## 8. New location checklist

- [ ] Location is compact enough for mobile.
- [ ] Path is readable.
- [ ] Collision boundaries are clear.
- [ ] Spawn point is safe.
- [ ] Transition markers are visible.
- [ ] Atmosphere does not hide gameplay.

## 9. HUD checklist

- [ ] Center of playfield remains visible.
- [ ] Joystick is lower-left.
- [ ] Actions are lower-right.
- [ ] Pause is compact and reachable.
- [ ] Bars are readable.
- [ ] Labels are Russian.
- [ ] Pressed state is visible.

## 10. Android test checklist

- [ ] Landscape verified.
- [ ] Touch movement verified.
- [ ] Attack/dodge verified.
- [ ] Interaction verified.
- [ ] Pause/menu verified.
- [ ] Journal/inventory verified.
- [ ] No blurry scaling.
- [ ] Screenshot review done.

## 11. Save/load checklist

- [ ] Save file created safely.
- [ ] Missing save handled.
- [ ] Corrupted save handled.
- [ ] Respawn data saved.
- [ ] Quest state saved.
- [ ] Inventory state saved.

## 12. Combat checklist

- [ ] Attack costs stamina.
- [ ] Dodge costs stamina.
- [ ] Hitboxes are timed.
- [ ] Hurtboxes work.
- [ ] Enemy telegraph exists.
- [ ] Hit feedback exists.
- [ ] Death/respawn safe.

## 13. Release candidate checklist

- [ ] Playable loop complete.
- [ ] Android QA completed.
- [ ] Manifest validated.
- [ ] Credits and licenses current.
- [ ] No unresolved blockers.
- [ ] Export path documented.
- [ ] Changelog updated.

## 14. Full release checklist

- [ ] Final art replaced placeholders.
- [ ] Performance verified on target device class.
- [ ] All licenses archived.
- [ ] All save migrations stable.
- [ ] Export signing set up.
- [ ] Device QA sign-off complete.
- [ ] Release notes prepared.

