#!/usr/bin/awk
# 
# usage "/home$ awk -f TE.awk > outfile"
#
#Reference: Tufenkji and Elimelech, Environ. Sci. Technol. 2004, Vol. 38, pages 529-536.				

#This awk script calculates the single-collector contact efficiency (h0) based on the T&E correlation equation (eq 17 in above reference).  
	
# Parameter set for the Sepia Ink colloids
#----------------------------------------------------
# Parameters		Units
# Collector diameter (dc)	0.320	mm
# Fluid approach velocity (U)	1.6E-03	m/s			
# Particle density (ρp)	1270	kg/m3			
# Fluid density (ρf)	1000	kg/m3	
# Fluid viscosity (µ)	1.005E-03	kg/m s
# Temperature (T)	293	K
# Hamaker constant (A)	1.0E-21	J
# Porosity (f)	0.51	-
# Happel model parameter (As)	20.35	-
#----------------------------------------------------

BEGIN{
Porosity = 0.51;
Dcol = 0.32;
Dpar = 0.08;
Fvisc=1.005e-3;
U=4.7e-4;
Temp= 293;
PI=3.1416;
Pdens=1270;
Fdens=1000;
g=9.8;
kB= 1.38e-23;
Hamaker=1e-21;



#printf "#Dp(Micron)\tnuD\tnuI\tnuG\tnu0\n"
printf "#U(m/s)\tnuD\tnuI\tnuG\tnu0\n"


for(J=0; J<4; J++)
{
var=0.0;

for(I=0;I<100; I++)
{


#Dpar = Dpar +  0.01
# This part of code is used to create a oredered scale of  x values
  var  = var +  2.0e-5;
#Dpar  var = var +  0.05

#In this case the x-axis is the fuid approach velocity
U=var;


Asparam= happel(Porosity);

#As=20.35;



NRatio = Dpar/(Dcol*1000);


NPe=(6*(PI)*Fvisc*(Dcol*0.001)*(Dpar*0.0000005)*U)/(Temp*kB);

NvdW=Hamaker/(Temp*kB);


NA=NvdW/(NRatio*NPe);

NG= 2/9 * ( Pdens - Fdens )* g * ((Dpar*5.0E-7)^2) /(Fvisc*U);

#Uncomment for testing
#printf "%6.5e %6.5e  %6.5e %6.5e  %6.5e %6.5e %6.5e\n",Dpar, Asparam,NRatio,NPe,NvdW,NA,NG

nuD= nud(Asparam,NRatio,NPe,NvdW);
nuI = nui(Asparam,NRatio,NA);
nuG= nug(NRatio,NG,NvdW);

nu0 = nuD + nuI + nuG;

printf "%4.3e\t%4.3e\t %4.3e\t%4.3e\t%4.3e\n",var,nuD,nuI,nuG,nu0
} # End of loop (I)


printf "\n\n"


Dpar=Dpar*2


} # End of loop (J)


} # End of BEGIN


# ===========================================================================
# =============        Declaration of Functions    ==========================
# ===========================================================================
# Verified
#vie sep 12 11:48:42 CEST 2014

#--------------------------------------------------------------
 #Happel model parameter
function happel(poros)
{
gam = (1.0 - poros)^(1/3);
resp = 2.0 * (1 - gam^5) /( 2 - 3*gam + (3*gam)^5 - (2*gam)^6);
return(resp)
}
#--------------------------------------------------------------


function nud(As,NRatio,NPe,NvdW)
{
nuD=2.4 *As^(1/3) * NRatio^-0.081 * NPe^-0.715 * NvdW^0.052;
return(nuD)
}

function nui(As,NRatio,NA)
{
nuI=0.55 * As * NRatio^1.675 * NA^0.125;
return(nuI)
}

function nug(NRatio,NG,NvdW)
{
nuG = 0.22 * NRatio^-0.24 * NG^1.11 * NvdW^0.053;
return(nuG)
}

# ===========================================================================


