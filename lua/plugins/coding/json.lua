return {
  {
    'Owen-Dechow/nvim_json_graph_view',
    dependencies = {
      'Owen-Dechow/graph_view_yaml_parser', -- Optional: add YAML support
      'Owen-Dechow/graph_view_toml_parser', -- Optional: add TOML support
      -- 'a-usr/xml2lua.nvim', -- Optional | Experimental: add XML support
    },
    opts = {
      editor_type = 'floating', -- 'split|floating'
      box_style = 'sharp', -- square connective lines (was round_units = false)
      line_style = 'sharp', -- square cell borders (was round_units = false)
    },
  },
}
