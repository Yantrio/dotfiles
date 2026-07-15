return {
  'sphamba/smear-cursor.nvim',
  event = 'VeryLazy',
  ---@type SmearCursor.Config
  opts = {
    -- Tweak feel: lower = snappier, higher = more drag
    stiffness = 0.6,
    trailing_stiffness = 0.4,
    distance_stop_animating = 0.5,
  },
}
