#===============================================
# Plotting TE correlation functions
# genuplot:
#
# José Eugenio López Periago
# Universidade de Vigo
# vie sep 26 20:45:56 CEST 2014
#===============================================


set style line 1 lw 2 lc   rgb "red"  lt 1 pt 7
set style line 2 lw 2 lc rgb "green" lt 1 pt 7
set style line 3 lw 2 lc rgb "blue" lt 1  pt 7
set style line 4 lw 3 lc rgb "black" lt 3  pt 7
set style line 5 lw 2 lc rgb "red" lt 1  pt 7 ps 2
set style line 6 lw 3 lc rgb "gray" lt 3  pt 7

set terminal post enhance eps color 24
set output "TE_Correlation_ink.eps"

set multiplot

set xrange [5e-5:2e-3]
set yrange [2e-4:5e-3]

set xtics (1e-4,2e-4,5e-4,1e-3)
set ytics (2e-4,5e-4,1e-3,0.002,0.005)



set xlabel "Fluid approach velocity (m s^{-1})"
set ylabel "Collision efficiency {/Symbol h} [-]"

set logscale x
set logscale y

set format x "%1.0e"
set format y "%1.0e"


plot '< awk -f ./TE.awk' u 1:2 t "{/Symbol h}_D"  w l ls 1,\
'< awk -f ./TE.awk' u 1:3 t "{/Symbol h}_I" w l ls 2,\
'< awk -f ./TE.awk' u 1:4 t "{/Symbol h}_G" w l ls 3,\
'< awk -f ./TE.awk' u 1:5  t "{/Symbol h}_0 = {/Symbol h}_D+{/Symbol h}_I+{/Symbol h}_G"  w l ls 4,\
'-' t "Sepia Ink"  w p ls 5, '-' t ""  w l ls 6
8.13e-4 5.598e-4 
e 
8.13e-4 1e-9
8.13e-4 5.598e-4
e



set size 0.45
set origin 0.16, 0.19
set noylabel
set noxlabel

set yrange [1e-9:8e-3]


set xtics (1e-4,1e-3) font "12"
set ytics (1e-9,1e-7,1e-5,1e-3) font "12"


plot '< awk -f ./TE.awk' u 1:2 t ""  w l ls 1,\
'< awk -f ./TE.awk' u 1:3 t "" w l ls 2,\
'< awk -f ./TE.awk' u 1:4 t "" w l ls 3,\
'< awk -f ./TE.awk' u 1:5  t ""  w l ls 4,\
'-' t ""  w p ls 5, '-' t ""  w l ls 6
8.13e-4 5.598e-4 
e 
8.13e-4 1e-9
8.13e-4 5.598e-4
e
