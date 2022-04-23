/* disloc.c -- Computes surface displacements for dislocations in an elastic half-space.
   Based on code by Y. Okada.  C version and mex interface by P. Cervelli.
   Version 1.1, 8/25/98
  
   Record of revisions:

   Date          Programmer            Description of Change
   ====          ==========            =====================
   09/01/2000    Peter Cervelli        Fixed a bug that incorrectly returned an integer absolute value
                                       that created a discontinuity for dip angle of +-90 - 91 degrees.
                                       A genetically related bug incorrectly assigned a value of 1 to 
                                       sin(-90 degrees).
   08/25/1998    Peter Cervelli        Original Code


*/

#include <math.h>
#include <mex.h>
#include <string.h>

#define DEG2RAD 0.017453292519943295L
#define PI2INV 0.15915494309189535L

void Okada(double *pSS, double *pDS, double *pTS, double alp, double sd, double cd, double len, double wid, 
		   double dep, double X, double Y, double SS, double DS, double TS)
{
	double depsd, depcd, x, y, ala[2], awa[2], et, et2, xi, xi2, q2, r, r2, r3, p, q, sign;
	double a1, a3, a4, a5, d, ret, rd, tt, re, dle, rrx, rre, rxq, rd2, td, a2, req, sdcd, sdsd, mult;
	int j, k;

	ala[0] = len;
	ala[1] = 0.0;
	awa[0] = wid;
	awa[1] = 0.0;
	sdcd = sd * cd;
	sdsd = sd * sd;
	depsd = dep * sd;
	depcd = dep * cd;

	p = Y * cd + depsd;
	q = Y * sd - depcd;

	for (k = 0; k <= 1; k++)
	{
		et = p - awa[k];
		for (j = 0; j <= 1; j++)
		{
			sign = PI2INV;
			xi = X - ala[j];
			if (j + k == 1)
				sign = -PI2INV;
			xi2 = xi * xi;
			et2 = et * et;
			q2 = q * q;
			r2 = xi2 + et2 + q2;
			r = sqrt(r2);
			r3 = r * r2;
			d = et * sd - q * cd;
			y = et * cd + q * sd;
			ret = r + et;
			if (ret < 0.0)
				ret = 0.0;
			rd = r + d;
			if (q != 0.0)
				tt = atan(xi * et / (q * r));
			else
				tt = 0.0;
			if (ret != 0.0)
			{
				re = 1 / ret;
				dle = log(ret);
			}
			else
			{
				re = 0.0;
				dle = -log(r - et);
			}
			rrx = 1 / (r * (r + xi));
			rre = re / r;
			if (cd == 0.0)
			{
				rd2 = rd * rd;
				a1 = -alp / 2 * xi * q / rd2;
				a3 = alp / 2 * (et / rd + y * q / rd2 - dle);
				a4 = -alp * q / rd;
				a5 = -alp * xi * sd / rd;
			}
			else
			{
				td = sd / cd;
				x = sqrt(xi2 + q2);
			
				if (xi == 0.0)
					a5 = 0;
				else
					a5 = alp * 2 / cd * atan( (et * (x + q * cd) + x * (r + x) * sd) / (xi * (r + x) * cd) );

				a4 = alp / cd * (log(rd) - sd * dle);
				a3 = alp * (y / rd / cd - dle) + td * a4;
				a1 = -alp / cd * xi / rd - td * a5;
			}

			a2 = -alp * dle - a3;
			req = rre * q;
			rxq = rrx * q;
			
			if (SS != 0)
			{
				mult = sign * SS;
				pSS[0] -= mult * (req * xi + tt + a1 * sd);
				pSS[1] -= mult * (req * y + q * cd * re + a2 * sd);
				pSS[2] -= mult * (req * d + q * sd * re + a4 * sd);
			}
		
			if (DS != 0)
			{
				mult = sign * DS;
				pDS[0] -= mult *(q / r - a3 * sdcd);
				pDS[1] -= mult * (y * rxq + cd * tt - a1 * sdcd);
				pDS[2] -= mult * (d * rxq + sd * tt - a5 * sdcd);
			}
			if (TS != 0)
			{
				mult = sign * TS;
				pTS[0] += mult * (q2 * rre - a3 * sdsd);
				pTS[1] += mult * (-d * rxq - sd * (xi * q * rre - tt) - a1 * sdsd);
				pTS[2] += mult * (y * rxq + cd * (xi * q * rre - tt) - a5 * sdsd);
			}
		}
	}
}

int GoodModel(double *pModel)
{
	double test;
	test = pModel[2]-sin(pModel[3]*DEG2RAD)*pModel[1];
	if (pModel[0]<0 || pModel[1]<0 || pModel[2]<0 || test<-1e-12)
		return 0;
	else
		return 1;
}


void Disloc(double *pOutput, double *pModel, double *pCoords, double nu, int NumStat, int NumDisl,
			int RefStat)
{
	int i,j, sIndex, dIndex, kIndex;
	double  alp, sd, cd, Angle, cosAngle, sinAngle, HalfLength, x,y, X, Y,SS[3],DS[3],TS[3], S[3];

	alp = 1 - 2 * nu;

	/*Loop through dislocations*/

		for (i=0; i< NumDisl; i=i++)
		{
			dIndex=i*10;
			if (GoodModel(&pModel[dIndex]))
			{

				if (pModel[dIndex+3] == 90.0)
				{
					cd = 0.0;
					sd = 1.0;
				}
				else if (pModel[dIndex+3] == -90.0)
				{
					cd = 0.0;
					sd = -1.0;
				}
				else
				{
					cd = cos(pModel[dIndex+3] * DEG2RAD);
					sd = sin(pModel[dIndex+3] * DEG2RAD);
				}

				Angle = -(90 - pModel[dIndex+4]) * DEG2RAD;
				cosAngle = cos(Angle);
				sinAngle = sin(Angle);
				HalfLength = 0.5 * pModel[dIndex];	
		
				/*Loop through stations*/

				for(j=0; j < NumStat; j++)
				{
					SS[0] = SS[1] = SS[2] = 0;
					DS[0] = DS[1] = DS[2] = 0;
					TS[0] = TS[1] = TS[2] = 0;

					sIndex = j*2;
					kIndex = j*3;
					x = pCoords[sIndex] - pModel[dIndex+5];
					y = pCoords[sIndex + 1] - pModel[dIndex+6];
					X = cosAngle * x - sinAngle * y + HalfLength;
					Y = sinAngle * x + cosAngle * y;
			
					Okada(&SS[0],&DS[0],&TS[0],alp,sd,cd,pModel[dIndex],pModel[dIndex+1],pModel[dIndex+2],X,Y,pModel[dIndex+7], pModel[dIndex+8], pModel[dIndex+9]);
					
					if (pModel[dIndex+7])
					{
						x=SS[0];
						y=SS[1];
						SS[0] = cosAngle * x + sinAngle * y;
						SS[1] = -sinAngle * x + cosAngle * y;
						pOutput[kIndex]+=SS[0];
						pOutput[kIndex+1]+=SS[1];
						pOutput[kIndex+2]+=SS[2];
					}

					if (pModel[dIndex+8])
					{
						x=DS[0];
						y=DS[1];
						DS[0] = cosAngle * x + sinAngle * y;
						DS[1] = -sinAngle * x + cosAngle * y;
						pOutput[kIndex]+=DS[0];
						pOutput[kIndex+1]+=DS[1];
						pOutput[kIndex+2]+=DS[2];
					}

					if (pModel[dIndex+9])
					{
						x=TS[0];
						y=TS[1];
						TS[0] = cosAngle * x + sinAngle * y;
						TS[1] = -sinAngle * x + cosAngle * y;
						pOutput[kIndex]+=TS[0];
						pOutput[kIndex+1]+=TS[1];
						pOutput[kIndex+2]+=TS[2];

					}
				}
			}
			else {
				mexWarnMsgTxt("Unphysical model.");
			}

		}

		if (RefStat)
		{
			kIndex=(RefStat-1)*3;
			S[0]=pOutput[kIndex];
			S[1]=pOutput[kIndex+1];
			S[2]=pOutput[kIndex+2];
			memmove(&pOutput[kIndex],&pOutput[kIndex+3],(NumStat-RefStat)*24);

			for (i=0; i<NumStat-1; i++)
			{
				kIndex=i*3;
				pOutput[kIndex]-=S[0];
				pOutput[kIndex+1]-=S[1];
				pOutput[kIndex+2]-=S[2];
			}

		}

	}



void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	double *pOutput;
	double *pModel, *pCoords, *pOptions;
	double nu;
	int i, m, n, NumStat, NumDisl, RefStat;

	int relFlag = 0;

	/*Check argument syntax*/


	if (nrhs < 3 ||  nrhs > 4 || nlhs > 1)
		{
			mexPrintf("disloc 1.1    09/02/2000\nUsage: [G]=Disloc(model,stations,nu,{refstat})\n");
			return;
		}
	/*Check model vector*/

		m=mxGetM(prhs[0]);
		NumDisl=mxGetN(prhs[0]);

		if (m/10.0 != floor(m/10.0))
			mexErrMsgTxt("First argument must be a 10xn matrix containing n dislocations, stored columnwise.");

		pModel = mxGetPr(prhs[0]);

		
	/*Check station coordinate matrix*/

		m=mxGetM(prhs[1]);
		n=mxGetN(prhs[1]);

		if (m != 2)
			mexErrMsgTxt("Second argument must be a 2xn matrix containing n station coordinates, stored columnwise.");

		NumStat=n;
		pCoords = mxGetPr(prhs[1]);


	/*Check Poisson's ratio*/

		m=mxGetM(prhs[2]);
		n=mxGetN(prhs[2]);

		if (m != 1 || n != 1)
			mexErrMsgTxt("Third argument must be a scalar (Poisson's ratio).");

		nu =  mxGetScalar(prhs[2]);

	/*Check for reference station*/
		
		if (nrhs == 4)
		{
			m=mxGetM(prhs[3]);
			n=mxGetN(prhs[3]);

			if (m != 1 || n != 1)
				mexErrMsgTxt("Fourth argument must be a scalar (reference station).");

			RefStat=mxGetScalar(prhs[3]);
		}
		else
			RefStat=0;



	/*Create output array and call main function*/

		plhs[0] = mxCreateDoubleMatrix(3, NumStat, mxREAL);
		pOutput = mxGetPr(plhs[0]);

		Disloc(pOutput, pModel, pCoords, nu, NumStat, NumDisl, RefStat);

		if (RefStat)
			mxSetN(plhs[0],NumStat-1); 


}