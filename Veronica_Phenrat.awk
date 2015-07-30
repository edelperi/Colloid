#!/usr/bin/awk
# 
# usage "/home$ awk -f Veronica_Phenrat.awk > outfile"
#
#Reference: Tufenkji and Elimelech, Environ. Sci. Technol. 2004, Vol. 38, pages 529-536.			
#Correlation Equation for Predicting Attachment Efficiency (α) of Organic Matter-Colloid Complexes in Unsaturated Porous Media. Verónica L. Morales,Wenjng Sang,Daniel R. Fuka, Leonard W. Lion, Bin Gao,and Tammo S. Steenhuis,
#Environ. Sci. Technol. 2011, 45, 10096–10101
#dx.doi.org/10.1021/es2023829

	

#This awk script calculates the single-collector contact efficiency (h0) based on the T&E correlation equation (eq 17 in above reference).  
	
# Parameter set for the Sepia Ink
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
Dcol = 0.32e-3;
Dpar = 0.15e-6;
Dpol = 0.15e-5;#Longitud del polímero
Fvisc=1.005e-6;# Viscosidad dinamica del fluido (MKS)
U=4.7e-6;
Temp= 293;
PI=3.1416;
Pdens=1270;
Fdens=1000;
g=9.8;
kB= 1.38e-23;
Hamaker=1e-21;
Diel= 80; # Permitividad relativa del agua
epsilon0=8.8541e-12 #Permitividad del vacío (F m^-1, C^2 m^-2 N^-1)
Zp = -0.045; # Potencial Zeta de la partícula (V)
Zc = -0.045; # Potencial Zeta del colector (V)
q= 1.0e-6; #Cobertura de polímero (kg m^2)
NA= 6.02e23; # Número de Avogadro (mol-1)
rhom= 1200.0; #Densidad del polímero (kg m^-3)
Mw = 7.0e5; #Masa molecular del polímero (tomada de  la carboxy methyl cellullos CMC Sigma-Aldrich)
Mw = 9.0e4; #Masa molecular del polímero (tomada de idem)

var1=0.0;

#printf "#Dp(Micron)\tnuD\tnuI\tnuG\tnu0\n"
printf "#q(kg/m2)\tDp(m)\tNlo\tNle\tNlek\talpha\n"

for(K=0; K< 10; K++)
{
  var1  = var1 +  1e-7;

#Dpar= var1;
var2=1e-10;

for(I=1; I< 100; I++)
{

q = var2;
#U=var;

# Options for polymer coating
#q = var; #q= 1.3e-5; #Poliomer coating  (kg m^2)


#Cálculo de funciones
Nlo = nlo(Hamaker,Dpar,U,Fvisc);

Ne1 = ne1(epsilon0,Diel,Zp,Zc,U,Fvisc,Dpar);

Nlek = nelek(Dpar,Dpol,U,q,NA,rhom,Fvisc,Mw);
#function nelek(dp,dm,u,q,NA,rhom,visc,Mw)



#Correlations to estimate 
#Attachment Efficiency of Natural Organic Matter-Coated Particles
#Phenrat et al 2010
#alpha_exp= 1E-1.35 * Nlo^0.39 * Ne1^-1.17 * Nlek^-0.10; 
#Morales et al., 2011
alpha_exp = (1E-0.86 * Nlo^(0.39) * Ne1^(-1.22) * Nlek^(-0.11)); 

printf "%4.3e\t%4.3e\t%4.3e\t%4.3e\t%4.3e\t%4.3e\n",var1,var2,Nlo,Ne1,Nlek,alpha_exp

#print "\n\nNlo^(0.39)  Ne1^(-1.22)   Nlek^(-0.11)\n"; 
#print Nlo^(0.39) , Ne1^(-1.22) , Nlek^(-0.11); 
#print log(alpha_exp)


var2  = var2 +  1e-5;

}
printf "\n\n"
}
}

# ===========================================================================
# =============        Declaration of Functions    ==========================
# ===========================================================================

# ---------------------------------------------------------------
# London number
function nlo(A,Dpar,U,visc)
{
nlondon= 4 * A / ( 9 * 3.1416 * Dpar^2 *  visc * U);
return(nlondon)
}
# ---------------------------------------------------------------


# ---------------------------------------------------------------
#  First electrokinetic parameter
#Ne1 = ne1(epsilon0,Diel,Zp,Zc,U,Fvisc,Dpar);
function ne1(epsilon0,epsilon,Zp,Zc,U,visc,Dp)
{
neelec= epsilon0*epsilon*(Zp^2 + Zc^2)/( 3 * 3.1416 * Dpar *  visc * U);
return(neelec)
}
# ---------------------------------------------------------------


# ---------------------------------------------------------------
#  Second electrokinetic parameter (Not used for the Veronica approach)
function ne2(Zp,Zc)
{
nelec2=  2*Zp*Zc/( Zp^2 + Zc^2);
return(nelec2)
}
# ---------------------------------------------------------------
# ---------------------------------------------------------------
#  Double-layer force parameter (Not used here)
function ndl(k,Dp)
{
ndl= k*Dp;
return(ndl)
}
# ---------------------------------------------------------------
#  Double-layer-electrokinetic parameter
#Nlek = nlek(Dpar,Dpol,U,q,NA,rhom,Fvisc,Mw);
function nelek(dp,dm,u,q,NA,rhom,visc,Mw)
{
res= ( dp * dm^2 * u * q * NA * rhom) /( visc * Mw)
return(res)
}
# ---------------------------------------------------------------


