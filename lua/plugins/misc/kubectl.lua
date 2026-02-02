return {
  {
    'ramilito/kubectl.nvim',
    cmd = { 'Kubectl', 'Kubectx', 'Kubens' },
    version = '2.*',
    dependencies = 'saghen/blink.download',
		-- stylua: ignore
		keys = {
			{ '<leader>8', function() vim.cmd[[tabnew]]; require('kubectl').open() end, desc = 'Kubectl' },
		},
    opts = {},
  },
}
