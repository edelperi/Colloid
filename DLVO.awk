#!/usr/bin/awk
BEGIN{ FS " "; RS "\n";
#Declaración de constantes  Físicas
pi=3.1416;
Na= 6.02e23; # Número de Avogadro (mol^-1)
Z = 1 # valencia del cation (entero)
C = 1.6e-19; # carga del electron (C)
kB=1.38e-23; # Constante de Boltzmann (J K^-1)
CD = 6.94e-10; # constante dieléctrica
# Declaración de variables dependientes de la naturaleza del sistema 
# Partícula Colector
Hamaker = 1e-20;
rColoide =75.0e-7; # Radio de la partícula coloidal (m)
rColector = 0.32e-3; # Radio del colector esférico (m)
I=1e-3; #Fuerza ionica (mol L^-1)
Vcoloide= 50e-3; # Potencial en voltios
Vcolector= 50e-3; # Potencial en voltios
T = 293; # Temperatura absoluta (K)
}
#=======================================================
#          Fin de la declaración de cabecera
#=======================================================
{ 
#Lee las siete  variables del archivo de entrada DLVO.input
Hamaker =  $1; #Energía de Hamaker (J)
rColoide = $2; # Radio de la partícula coloidal (m)
rColector = $3; # Radio del colector esférico (m)
I= $4; #Fuerza ionica (mol L^-1)
Vcoloide= $5; # Potencial en voltios
Vcolector= $6; # Potencial en voltios
T = $7 # Temperatura absoluta (K)

kappa = sqrt((2*(I*Na)* C**2 * Z**2 )/(kB*T*CD));

print "Hamaker, rColoide, rColector, I, Vcoloide, Vcolector, T, kappa";
print Hamaker, rColoide, rColector, I, Vcoloide, Vcolector,T,kappa;

I=1e-4

for (K=1;K<4;K++)
{


I = I * 10

printf "# I = %4.3f mol\n",I

kBT = T * kB;
#=======================================================
#Calculo de la distancia de Debye
kappa = sqrt((2*(I*Na)* C**2 * Z**2 )/(kB*T*CD));
#=======================================================


x=0.0

print "# x(m)  VelkBT VvdWkBT Vtot_(kBT)"
for(J=1;J<1000;J++)
{

x = x + 5e-10 # Separación en metros


#=======================================================
#               DECLARACION DE FUNCIONES 
#=======================================================


term1= 2*Vcoloide*Vcolector*log((1+exp(-kappa*x))/(1-exp(-kappa*x)))

term2= (Vcoloide**2 + Vcolector**2) * log(1-exp(-2*kappa*x))



#================================================================
#Interacción electrostática
Vel = (3.1416 * CD * rColoide * rColector)/(rColoide+rColector)*(term1+term2);

VelkBT = Vel/kBT; 
#print x,term1,term2,Vel,VelkBT,kBT
#================================================================


#================================================================
# Interaccion de Van der Waals
# Esfera-Esfera, cuando rColector >> x (mucho mayor que la distancia de separación)
VvdW= -Hamaker*rColoide*rColector/(6.0*x *(rColoide+rColector));

VvdWkBT=VvdW/kBT;
#================================================================

#================================================================
# Interaccion  total expresada en unidades  de enrgía térmica kB T)

Vtot =(VvdWkBT+VelkBT)


printf "%4.3e\t%4.3e\t%4.3e\t%4.3e\n",x,VelkBT,VvdWkBT,Vtot
}

print "\n\n"

}


}


END{
}


