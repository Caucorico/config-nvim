-- le leader est espace
vim.g.mapleader = " "

-- Pour naviguer entre les fenêtres
vim.keymap.set('n', '<C-c>', '<C-w>h')
vim.keymap.set('n', '<C-t>', '<C-w>j')
vim.keymap.set('n', '<C-s>', '<C-w>k')
vim.keymap.set('n', '<C-r>', '<C-w>l')


vim.opt.expandtab   = true
vim.opt.shiftwidth  = 2
vim.opt.tabstop     = 2
vim.opt.softtabstop = 2

vim.cmd([[
  set langmap=$`,\\"1,«2,»3,(4,)5,@6,+7,-8,/9,*0,=-,%=,bq,éw,pe,or,èt,çy,vu,di,lo,jp,z[,w],aa,us,id,ef,\\,g,ch,tj,sk,rl,n\\;,m',ê<,àz,yx,xc,.v,kb,’n,qm,g\\,,h.,f/,#~,1!,2@,3#,4$,5%,6^,7&,8*,9(,0),°_,`+,BQ,ÉW,PE,OR,ÈT,ÇY,VU,DI,LO,JP,Z{,W},AA,US,ID,EF,\\;G,CH,TJ,SK,RL,N:,M\\",Ê>,ÀZ,YX,XC,:V,KB,?N,QM,G<,H>,F?
]])

-- On désactive la souris
vim.opt.mouse = ""

require("config.lazy")
