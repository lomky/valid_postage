the recursive function:
- checks if we're too deep, returns it we are
- adds our highest denom to the sub total
 - if we've met our total, add this to valid combos
 - else increment depth and call again
- remove the largest denom and call again at the same depth

as written this ends up doing a lot of unnecessary calls. if we fail make any set with a denominations, we should cut early out of that branch
function needs to track:
- depth (aka stamp limit)
- total postage needed
- array of applied postage (subtotal derives from here)
- ?a flag to cut out early on dead branches?
  - ?if we hit the too deep trigger without having saved a valid combo starting with the highest denom, cut out?

Bonus considerations:
  - limit overpaying to a specific quantity (final check on otherwise valid combos)
