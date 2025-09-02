from multiprocessing import Pool
import numpy as np
import pandas as pd
from scipy import interpolate as intp
from scipy.signal import butter, lfilter, freqz, filtfilt
from matplotlib import pyplot as plt
import matplotlib.patches as patches
from geopy.distance import geodesic

from PIL import Image

from scipy import integrate


def getWindVector(velN, velE, velD, airspeed, pitch, roll, yaw, aoa, aos):
    #YAW：北方位が0deg、機体を上から見て時計回りが正方向、Z軸回り
    #ROLL：水平が0deg、機体を後方から見て時計回り（右バンク）が正方向、X軸周り
    #PITCH：水平が0deg、ピッチ上げが正方向、Y軸周り
    #X軸：機体進行方向、前方が正方向
    #Y軸：機体並進方向、進行方向に対して、右翼方向が正方向
    #Z軸：重力方向、下方向が正方向
    #AOA：機体進行方向と機体下方方向の成す角度、ピッチ下げ方向が正
    #AOS：機体進行方向と進行方向に対して、右翼方向が成す角度、ヨー方向が正

    if yaw > 360:
        yaw -= 360
    elif yaw < 0:
        yaw += 360    
    #airspeed = -airspeed
    aos = -aos
    cr = np.cos(np.radians(-roll))
    sr = np.sin(np.radians(-roll))
    cp = np.cos(np.radians(pitch))
    sp = np.sin(np.radians(pitch))
    cy = np.cos(np.radians(yaw))
    sy = np.sin(np.radians(yaw))
    
    caoa = np.cos(np.radians(aoa))
    saoa = np.sin(np.radians(aoa))
    caos = np.cos(np.radians(aos))
    saos = np.sin(np.radians(aos))

    U = airspeed * caoa * caos #機体進行方向速度, 前方が正, 単位はm/s
    V = airspeed * caoa * saos #体並進方向速度, 右翼正  , 単位はm/s
    W = airspeed * saoa * caos #機体下降方向速度、下方向正, 単位はm/s
    
    #cosφ：cr, sinφ：sr, φ：roll
    #cosΘ：cp, sinΘ：sp, Θ：pitch
    #cosψ：cy, sinψ：sy, ψ：yaw
    """
    
        [cy  -sy   0] ( [cp    0   sp] [1    0     0] )
    R = [sy   cy   0] | [ 0    1    0] [0   cr   -sr] |
        [ 0    0   1] ( [-sp   0   cp] [0   sr    cr] )
    
    [V_N_ac]     [U]
    [V_E_ac] = R [V]
    [V_D_ac]     [W]

    """
    V_N_ac = (cp*cy)*U + (sr*sp*cy-cr*sy)*V + (cr*sp*cy+sr*sy)*W
    V_E_ac = (cp*sy)*U + (sr*sp*sy+cr*cy)*V + (cr*sp*sy-sr*sy)*W
    V_D_ac = (-sp)  *U + (sr*cp)         *V + (cr*cp)         *W
    
    V_N_w = V_N_ac - velN 
    V_E_w = V_E_ac - velE
    V_D_w = V_D_ac - velD
    WINDSPEED = np.sqrt(V_N_w**2 + V_E_w**2 + V_D_w**2)
    
    return V_N_w, V_E_w, V_D_w, WINDSPEED