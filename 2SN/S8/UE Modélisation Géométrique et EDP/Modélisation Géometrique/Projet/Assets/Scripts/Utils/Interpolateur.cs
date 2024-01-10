﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;
using UnityEngine.UI;

public class Interpolateur : MonoBehaviour
{
    public float pas = 1f / 100f;
    public int time = 0;
    GameObject cameraObject;

    private List<float> X_res = new List<float>();
    private List<float> Y_res = new List<float>();
    private List<float> Z_res = new List<float>();

    private List<float> X_point = new List<float>();
    private List<float> Y_point = new List<float>();
    private List<float> Z_point = new List<float>();

    float centerX;
    float centerY;
    float centerZ;

    List<float> T = new List<float>();
    List<float> tToEval = new List<float>();

    private List<Vector3> P2DRAW = new List<Vector3>();

    //////////////////////////////////////////////////////////////////////////
    // fonction : buildParametrisationTchebycheff                           //
    // semantique : construit la parametrisation basée sur Tchebycheff      //
    //              et les échantillons de temps selon cette parametrisation//
    // params :                                                             //
    //          - int nbElem : nombre d'elements de la parametrisation      //
    //          - float pas : pas d'échantillonage                          //
    // sortie :                                                             //
    //          - List<float> T : parametrisation Tchebycheff               //
    //          - List<float> tToEval : echantillon sur la parametrisation  //
    //////////////////////////////////////////////////////////////////////////
    private (List<float>, List<float>) buildParametrisationTchebycheff(int nbElem, float step)
    {
        // Vecteur des pas temporels
        List<float> T = new List<float>();
        // Echantillonage des pas temporels
        List<float> tToEval = new List<float>();

        // Construction des pas temporels
        for (int i = 0 ; i < nbElem; i++) {
            T.Add(Mathf.Cos(((2*i + 1) * Mathf.PI) / (2*(nbElem - 1) + 2)));
        }
        T.Sort();

        // Construction des échantillons
        float curr_t = 0.0f;
        for (int i = 0; i < T.Count-1; i++) {
            curr_t = T[i];
            while (curr_t < T[i+1]) { // until the step reach the next sampled value
                tToEval.Add(curr_t);
                curr_t += pas;
            }
        }

        return (T, tToEval);
    }

    //////////////////////////////////////////////////////////////////////////
    // fonction : applyNevilleParametrisation                               //
    // semantique : applique la subdivion de Neville aux points (x,y)       //
    //              placés en paramètres en suivant les temps indiqués      //
    // params :                                                             //
    //          - List<float> X : liste des abscisses des points            //
    //          - List<float> Y : liste des ordonnées des points            //
    //          - List<float> T : temps de la parametrisation               //
    //          - List<float> tToEval : échantillon des temps sur T         //
    // sortie : rien                                                        //
    //////////////////////////////////////////////////////////////////////////
    private void applyNevilleParametrisation(List<float> X, List<float> Y, List<float> Z, List<float> T, List<float> tToEval)
    {
        // Apply Neville interpolation to the points (X, Y, Z) based on the provided times (T)
        P2DRAW.Clear();

        for (int i = 0; i < tToEval.Count; i++)
        {
            float t = tToEval[i];
            Vector3 point = neville(X, Y, Z, T, t);
            X_res.Add(point[0]);
            Y_res.Add(point[1]);
            Z_res.Add(point[2]);
            P2DRAW.Add(point);
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // fonction : neville                                                   //
    // semantique : calcule le point atteint par la courbe en t sachant     //
    //              qu'elle passe par les (X,Y) en T                        //
    // params :                                                             //
    //          - List<float> X : liste des abscisses des points            //
    //          - List<float> Y : liste des ordonnées des points            //
    //          - List<float> T : liste des temps de la parametrisation         //
    //          - t : temps ou on cherche le point de la courbe             //
    // sortie : point atteint en t de la courbe                             //
    //////////////////////////////////////////////////////////////////////////
    private Vector3 neville(List<float> X, List<float> Y, List<float> Z, List<float> T, float t)
    {
        List<float> xpoints = new List<float>();
        List<float> ypoints = new List<float>();
        List<float> zpoints = new List<float>();
        for(int i=0; i < Y.Count; i++) {
            xpoints.Add(X[i]);
            ypoints.Add(Y[i]);
            zpoints.Add(Z[i]);
        }
        for (int ligne=0 ; ligne < X.Count; ligne++) {
            for(int col=0; col < X.Count - ligne - 1; col++){
                xpoints[col] = (T[col+1+ligne] - t)/(T[col+1+ligne] - T[col]) * xpoints[col] + (t - T[col])/(T[col+1+ligne] - T[col]) * xpoints[col+1];
                ypoints[col] = (T[col+1+ligne] - t)/(T[col+1+ligne] - T[col]) * ypoints[col] + (t - T[col])/(T[col+1+ligne] - T[col]) * ypoints[col+1];
                zpoints[col] = (T[col+1+ligne] - t)/(T[col+1+ligne] - T[col]) * zpoints[col] + (t - T[col])/(T[col+1+ligne] - T[col]) * zpoints[col+1];
            }
        }
        return new Vector3(xpoints[0],ypoints[0],zpoints[0]);
    }


    private void GenerateTrajectoryPoints()
    {
        // Generate points for a tilted ellipse trajectory
        int numElements = 85;
        float step = 2f * Mathf.PI / numElements;
        float tiltAngleDegreesX = 15f; // Tilt angle in degrees for X-axis
        float tiltAngleDegreesY = 0f; // Tilt angle in degrees for Y-axis
        float tiltAngleDegreesZ = 20f; // Tilt angle in degrees for Z-axis
        float tiltAngleRadiansX = tiltAngleDegreesX * Mathf.Deg2Rad;
        float tiltAngleRadiansY = tiltAngleDegreesY * Mathf.Deg2Rad;
        float tiltAngleRadiansZ = tiltAngleDegreesZ * Mathf.Deg2Rad;

        for (int i = 0; i < numElements; i++)
        {
            float t = i * step;
            float x = 8f * Mathf.Cos(t);
            float y = 10f;
            float z = 8f * Mathf.Sin(t);

            // Apply rotation transformations
            float tiltedX = x * Mathf.Cos(tiltAngleRadiansX) + y * Mathf.Sin(tiltAngleRadiansX) * Mathf.Sin(tiltAngleRadiansY) + z * Mathf.Sin(tiltAngleRadiansX) * Mathf.Cos(tiltAngleRadiansY);
            float tiltedY = y * Mathf.Cos(tiltAngleRadiansY) - z * Mathf.Sin(tiltAngleRadiansY);
            float tiltedZ = -x * Mathf.Sin(tiltAngleRadiansX) + y * Mathf.Cos(tiltAngleRadiansX) * Mathf.Sin(tiltAngleRadiansY) + z * Mathf.Cos(tiltAngleRadiansX) * Mathf.Cos(tiltAngleRadiansY);

            X_point.Add(tiltedX);
            Y_point.Add(tiltedY);
            Z_point.Add(tiltedZ);
        }

        centerX = X_point.Average();
        centerY = Y_point.Average();
        centerZ = Z_point.Average();

        // Build parametrization and interpolate points
        (T, tToEval) = buildParametrisationTchebycheff(numElements, pas);
        applyNevilleParametrisation(X_point, Y_point, Z_point, T, tToEval);
    }



    private void Start()
    {
        cameraObject = GameObject.FindGameObjectWithTag("MainCamera");

        GenerateTrajectoryPoints();

        // Modify the lists X,Y,Z by the ellipse trajectory coordinates
        for (int i = 0; i < X_point.Count() ; i++) {
            X_res.Add(X_point[i]);  
            Y_res.Add(Y_point[i]);
            Z_res.Add(Z_point[i]);
        }

        // Add the first point to close the trajectory
        X_res.Add(X_point[0]);
        Y_res.Add(Y_point[0]);
        Z_res.Add(Z_point[0]);
    }

    private void Update()
    {
        if (cameraObject != null)
        {
            // Calculate camera position and rotation based on interpolated trajectory
            time = (time+1)%(tToEval.Count);
            Debug.Log("X_res Count: " + X_res.Count + " Time: " + time);
            Vector3 cameraPosition = new Vector3(X_res[time], Y_res[time],Z_res[time]);
            Quaternion cameraRotation = CalculateCameraRotation();

            // Set camera position and rotation
            cameraObject.transform.position = cameraPosition;
            cameraObject.transform.rotation = cameraRotation;
        }
    }

    private Quaternion CalculateCameraRotation()
    {   

        // Get the current position on the trajectory
        Vector3 currentPosition = new Vector3(X_res[time], Y_res[time], Z_res[time]);

        // Get the center of the ellipse
        Vector3 ellipseCenter = new Vector3(centerX, centerY, centerZ); // Replace centerX, centerY, centerZ with the actual center values

        // Calculate the direction from the current position to the ellipse center
        Vector3 direction = ellipseCenter - currentPosition;

        Quaternion targetRotation = Quaternion.LookRotation(direction, Vector3.up);

        // Interpolate the rotation
        float rotationSpeed = 0.5f;
        Quaternion interpolatedRotation = Quaternion.Slerp(cameraObject.transform.rotation, targetRotation, rotationSpeed * time);

        return interpolatedRotation;
    }

    private void OnDrawGizmos()
    {
        // Draw the interpolated trajectory in red using Gizmos
        Gizmos.color = Color.red;
        for (int i = 0; i < P2DRAW.Count - 1; i++)
        {
            Gizmos.DrawLine(P2DRAW[i], P2DRAW[i + 1]);
        }

        if (P2DRAW.Count > 0) {
            Gizmos.DrawLine(P2DRAW[P2DRAW.Count-1], P2DRAW[0]);
        }
    }
}
