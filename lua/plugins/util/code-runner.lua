return {
  'CRAG666/code_runner.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    filetype = {
      python = 'python3 -u',
      typescript = 'deno run',
      rust = {
        'cd $dir &&',
        'rustc $fileName &&',
        '$dir/$fileNameWithoutExt',
      },
    },
  },
  keys = {
    { '<f5>', '<cmd>RunCode<cr>', desc = 'Run code' },
    { '<leader>rc', '<cmd>RunCode<cr>', desc = 'Run code' },
    { '<leader>rp', '<cmd>RunProject<cr>', desc = 'Run project' },
  },
}
