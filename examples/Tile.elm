module Plotting where

import Html exposing (Html)
import Plot exposing (..)
import Plot exposing (..)
import Line.Interpolation exposing (linear)
import Scale
import Point exposing (Point)

main : Html
main =
  let
    xScale = Scale.linear (0.7491, 1.3483) (0, 400)
    yScale = Scale.linear (0, 551) (400, 0)
  in
  createPlot 400 400
    |> addLines lines .x .y xScale yScale linear []
    |> toSvg

lines : List Point
lines =
  [ { x = 0.7491, y = 0.0 }
   , { x = 0.7499, y = 16.5909445566991 }
   , { x = 0.7515, y = 20.4468873537021 }
   , { x = 0.7523, y = 10.7273364546924 }
   , { x = 0.7535, y = 17.4629351643001 }
   , { x = 0.7547, y = 14.5492508470446 }
   , { x = 0.7555, y = 16.4027402439185 }
   , { x = 0.7563, y = 14.6959714615189 }
   , { x = 0.7571, y = 9.16884238608612 }
   , { x = 0.7587, y = 300.603283921279 }
   , { x = 0.7605, y = 15.0839916733045 }
   , { x = 0.7611, y = 18.9955849632609 }
   , { x = 0.7623, y = 16.2933756195758 }
   , { x = 0.7629, y = 16.3260831729413 }
   , { x = 0.7647, y = 110.225069150504 }
   , { x = 0.7671, y = 19.2259367386646 }
   , { x = 0.7683, y = 17.6105962218528 }
   , { x = 0.7689, y = 17.9896317929151 }
   , { x = 0.7695, y = 14.8938914513986 }
   , { x = 0.7713, y = 19.9400525059115 }
   , { x = 0.7731, y = 5.27006026018646 }
   , { x = 0.7749, y = 4.28100938310337 }
   , { x = 0.7767, y = 4.63062370684243 }
   , { x = 0.7785, y = 6.40886376790261 }
   , { x = 0.7827, y = 16.3137425164987 }
   , { x = 0.7857, y = 3.82549567803501 }
   , { x = 0.7881, y = 0.743038029665954 }
   , { x = 0.7899, y = 2.78655233246643 }
   , { x = 0.7905, y = 7.21763175604229 }
   , { x = 0.7911, y = 22.9108023074374 }
   , { x = 0.7965, y = 278.837404208518 }
   , { x = 0.8031, y = 3.22398494701818 }
   , { x = 0.8037, y = 2.0171231954995 }
   , { x = 0.8061, y = 13.9695495882953 }
   , { x = 0.8103, y = 95.7066344191162 }
   , { x = 0.8163, y = 15.0837874777601 }
   , { x = 0.8181, y = 5.46771943153887 }
   , { x = 0.8211, y = 2.82342389011519 }
   , { x = 0.8229, y = 4.18275487007051 }
   , { x = 0.8241, y = 10.2961642703749 }
   , { x = 0.8301, y = 185.447344906576 }
   , { x = 0.8325, y = 215.306763388059 }
   , { x = 0.8349, y = 197.15469127749 }
   , { x = 0.8433, y = 34.8213136318093 }
   , { x = 0.8475, y = 26.4898328828585 }
   , { x = 0.8529, y = 2.21044318986079 }
   , { x = 0.8547, y = 4.16433513341768 }
   , { x = 0.8559, y = 10.9395003570897 }
   , { x = 0.8601, y = 97.2696352619021 }
   , { x = 0.8619, y = 110.130608083298 }
   , { x = 0.8679, y = 11.5569561184601 }
   , { x = 0.8703, y = 4.99208645707004 }
   , { x = 0.8739, y = 11.0601643137332 }
   , { x = 0.8745, y = 10.8219639219296 }
   , { x = 0.8769, y = 3.82767771922235 }
   , { x = 0.8793, y = 1.65232668958922 }
   , { x = 0.8817, y = 21.9458004292424 }
   , { x = 0.8871, y = 205.630060252071 }
   , { x = 0.8943, y = 6.42936991118904 }
   , { x = 0.8955, y = 4.75226576828952 }
   , { x = 0.9015, y = 41.1037014219131 }
   , { x = 0.9057, y = 32.2701236937042 }
   , { x = 0.9087, y = 34.9442688469314 }
   , { x = 0.9099, y = 33.9758825680903 }
   , { x = 0.9159, y = 8.00333857009566 }
   , { x = 0.9189, y = 3.25639279568845 }
   , { x = 0.9213, y = 9.45721864167601 }
   , { x = 0.9225, y = 24.7837718315042 }
   , { x = 0.9279, y = 148.48715760415 }
   , { x = 0.9285, y = 148.792224560072 }
   , { x = 0.9339, y = 74.7028546878808 }
   , { x = 0.9394, y = 155.483722302896 }
   , { x = 0.9415, y = 135.717622900234 }
   , { x = 0.9457, y = 20.4581135981129 }
   , { x = 0.9471, y = 4.79604182653673 }
   , { x = 0.9492, y = 1.69894655679389 }
   , { x = 0.9555, y = 14.6402502141611 }
   , { x = 0.9618, y = 5.57019942975804 }
   , { x = 0.9627, y = 5.53991017337171 }
   , { x = 0.9699, y = 8.680527748217 }
   , { x = 0.9717, y = 8.94117981933898 }
   , { x = 0.9753, y = 8.18694719771166 }
   , { x = 0.978, y = 7.98381794488339 }
   , { x = 0.9807, y = 8.47810428914901 }
   , { x = 0.987, y = 11.5948795131106 }
   , { x = 0.9879, y = 11.6560274291989 }
   , { x = 0.9924, y = 9.85011806689546 }
   , { x = 0.9996, y = 12.8483927662498 }
   , { x = 1.0023, y = 11.8437702204259 }
   , { x = 1.0068, y = 6.30025749201294 }
   , { x = 1.0095, y = 4.88963408501213 }
   , { x = 1.0113, y = 7.30400439258596 }
   , { x = 1.0248, y = 109.77633513107 }
   , { x = 1.0311, y = 194.033223100439 }
   , { x = 1.0338, y = 210.589275916909 }
   , { x = 1.0365, y = 192.598906876369 }
   , { x = 1.0446, y = 72.5536842637186 }
   , { x = 1.0563, y = 6.89740912828108 }
   , { x = 1.059, y = 5.6523139222945 }
   , { x = 1.0617, y = 6.65444249199817 }
   , { x = 1.0662, y = 11.4128210541452 }
   , { x = 1.0743, y = 30.1784106303454 }
   , { x = 1.0851, y = 74.2802524665694 }
   , { x = 1.0878, y = 65.5675440704149 }
   , { x = 1.0932, y = 17.3048301970178 }
   , { x = 1.0959, y = 10.6945361016904 }
   , { x = 1.0986, y = 18.1540079725722 }
   , { x = 1.1049, y = 55.1028604804945 }
   , { x = 1.1067, y = 53.442244413984 }
   , { x = 1.113, y = 33.9776057470233 }
   , { x = 1.1148, y = 34.8736869292075 }
   , { x = 1.1184, y = 42.0224092188867 }
   , { x = 1.1202, y = 42.9356809725714 }
   , { x = 1.1211, y = 41.9876579792403 }
   , { x = 1.1292, y = 15.9432854757551 }
   , { x = 1.131, y = 12.9305324515493 }
   , { x = 1.1328, y = 12.2886926053976 }
   , { x = 1.1346, y = 13.5115502109081 }
   , { x = 1.1382, y = 27.1962566506219 }
   , { x = 1.1454, y = 101.795942947897 }
   , { x = 1.1481, y = 113.504236609927 }
   , { x = 1.1508, y = 103.234262445362 }
   , { x = 1.1571, y = 39.9106127929588 }
   , { x = 1.1598, y = 27.4388596838482 }
   , { x = 1.1607, y = 26.3888171047527 }
   , { x = 1.1661, y = 31.0512196750172 }
   , { x = 1.176, y = 8.6911312748188 }
   , { x = 1.1796, y = 6.94352749253464 }
   , { x = 1.1868, y = 12.6361701321519 }
   , { x = 1.1895, y = 11.3771972704855 }
   , { x = 1.1931, y = 6.620967406739 }
   , { x = 1.1949, y = 5.86773561873376 }
   , { x = 1.1958, y = 6.41845510281717 }
   , { x = 1.1994, y = 20.171792378933 }
   , { x = 1.2057, y = 85.8288698012049 }
   , { x = 1.2075, y = 91.7750935607835 }
   , { x = 1.2129, y = 82.3103919952781 }
   , { x = 1.2156, y = 94.3061280221097 }
   , { x = 1.2219, y = 147.312134142996 }
   , { x = 1.2246, y = 131.466494864974 }
   , { x = 1.2318, y = 24.8720952968702 }
   , { x = 1.2354, y = 6.96078323701546 }
   , { x = 1.2372, y = 3.36690426815976 }
   , { x = 1.2381, y = 2.41131135212441 }
   , { x = 1.2399, y = 2.07091455126989 }
   , { x = 1.2408, y = 2.63774434437692 }
   , { x = 1.2426, y = 7.99139967465497 }
   , { x = 1.2444, y = 36.4226908627801 }
   , { x = 1.2507, y = 265.560670168887 }
   , { x = 1.2534, y = 303.017447943301 }
   , { x = 1.2633, y = 105.944355460548 }
   , { x = 1.2642, y = 102.642760132163 }
   , { x = 1.2696, y = 117.483818727642 }
   , { x = 1.2723, y = 106.867124237202 }
   , { x = 1.2795, y = 47.6133321599016 }
   , { x = 1.2883, y = 10.30098439029 }
   , { x = 1.2899, y = 6.37479598552756 }
   , { x = 1.2923, y = 4.66907644841141 }
   , { x = 1.2947, y = 7.75988746192121 }
   , { x = 1.2963, y = 16.9894494019909 }
   , { x = 1.3011, y = 100.609817141351 }
   , { x = 1.3035, y = 117.226576843997 }
   , { x = 1.3091, y = 58.8904757135394 }
   , { x = 1.3107, y = 12.7025699421613 }
   , { x = 1.3131, y = 24.4887961433065 }
   , { x = 1.3139, y = 69.0546204815363 }
   , { x = 1.3171, y = 551.400588492114 }
   , { x = 1.3227, y = 14.5331319445955 }
   , { x = 1.3235, y = 12.3352738994532 }
   , { x = 1.3243, y = 20.7243492558442 }
   , { x = 1.3251, y = 20.589271356362 }
   , { x = 1.3259, y = 22.8294009934264 }
   , { x = 1.3307, y = 13.180930565648 }
   , { x = 1.3331, y = 21.0510299347263 }
   , { x = 1.3339, y = 16.1000897069847 }
   , { x = 1.3355, y = 19.0461743804189 }
   , { x = 1.3379, y = 109.659503823593 }
   , { x = 1.3419, y = 15.3127619205359 }
   , { x = 1.3427, y = 19.5658748623239 }
   , { x = 1.3459, y = 217.476054040245 }
   , { x = 1.3483, y = 0.0 }
   ]
