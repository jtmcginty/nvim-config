-- ============================================================================
-- Jack's Neovim Configuration
-- ============================================================================
-- Entry point for Neovim configuration
-- This file loads the plugin manager and core settings

-- Load core settings first (leader key must be set before plugins)
require('config.settings')

-- Load performance optimizations
require('config.performance')

-- Initialize lazy.nvim plugin manager
require('config.lazy')
