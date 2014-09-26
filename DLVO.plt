set terminal post enhanced color 24
set output "DLVO.eps"

set xrange [1:20]
set xlabel "Separation distance (nm)"
#set xlabel "Distance ({/Symbol m}m)"
set ylabel "Potential  ({/Italic k}_B T)
 plot '< awk -f DLVO.awk < DLVO.input' i 0 u ($1*1e9):4 t "0.001 M"  w l 3,\
      '< awk -f DLVO.awk < DLVO.input' i 1 u ($1*1e9):4  t "0.01" w l 2,\
      '< awk -f DLVO.awk < DLVO.input' i 2 u ($1*1e9):4  t "0.1 M" w l 1,\
'-'  t "" w l 0
0 0
10 0
e

 plot '< awk -f DLVO.awk < DLVO.input' i 0 u ($1*1e9):2 t "Coulombic"  w l 3,\
      '< awk -f DLVO.awk < DLVO.input' i 0 u ($1*1e9):3  t "Van der Waals" w l 2,\
      '< awk -f DLVO.awk < DLVO.input' i 0 u ($1*1e9):4  t "Total" w l 1,\
'-'  t "" w l 0
0 0
10 0
e

plot '< awk -f DLVO.awk < DLVO.input' i 1 u ($1*1e9):2 t "Coulombic"  w l 3,\
      '< awk -f DLVO.awk < DLVO.input' i 1 u ($1*1e9):3  t "Van der Waals" w l 2,\
      '< awk -f DLVO.awk < DLVO.input' i 1 u ($1*1e9):4  t "Total" w l 1,\
'-'  t "" w l 0
0 0
10 0
e

plot '< awk -f DLVO.awk < DLVO.input' i 2 u ($1*1e9):2 t "Coulombic"  w l 3,\
      '< awk -f DLVO.awk < DLVO.input' i 2 u ($1*1e9):3  t "Van der Waals" w l 2,\
      '< awk -f DLVO.awk < DLVO.input' i 2 u ($1*1e9):4  t "Total" w l 1,\
'-'  t "" w l 0
0 0
10 0
e


reset

